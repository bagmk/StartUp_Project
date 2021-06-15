const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.onCreateFollower = functions.firestore.document("/followers/{userId}/userFollowers/{followerId}")
    .onCreate(async (snapshot, context) => {
        console.log("Follower Created", snapshot.id);
        const userId = context.params.userId;
        const followerId = context.params.followerId;

        // 1) Create followed users posts ref
        const followedUserPostsRef = admin
            .firestore()
            .collection("posts")
            .doc(userId)
            .collection("userPosts");

        // 2) Create following user's timeline ref
        const timelinePostsRef = admin
            .firestore()
            .collection("timeline")
            .doc(followerId)
            .collection("timelinePosts");

        // 3) Get followed users posts
        const querySnapshot = await followedUserPostsRef.get();

        // 4) Add each user post to following user's timeline
        querySnapshot.forEach(doc => {
            if (doc.exists) {
                const postId = doc.id;
                const postData = doc.data();
                timelinePostsRef.doc(postId).set(postData);
            }
        });
    });


exports.onDeleteFollower = functions.firestore.document("/followers/{userId}/userFollowers/{followerId}")
    .onDelete(async (snapshot, context) => {
        console.log("Follower Deleted", snapshot.id);
        const userId = context.params.userId;
        const followerId = context.params.followerId;

        const timelinePostsRef = admin
            .firestore()
            .collection("timeline")
            .doc(followerId)
            .collection("timelinePosts").where("ownerId", "==", userId);

        const querySnapshot = await timelinePostsRef.get();
        querySnapshot.forEach(doc => {
            if (doc.exists) {
                doc.ref.delete();
            }
        });

    });

exports.onCreatePost = functions.firestore.document('/posts/{userId}/userPosts/{postId}')
    .onCreate(async (snapshot, context) => {
        const postCreated = snapshot.data();
        const userId = context.params.userId;
        const postId = context.params.postId;

        //1) get all the followers of the user who made the post
        const userFollowersRef = admin.firestore().collection('followers').doc(userId).collection('userFollowers');
        const querySnapshot = await userFollowersRef.get();



        //2) Add new post to each follower's timeline

        querySnapshot.forEach(doc => {
            const followerId = doc.id;

            admin.firestore().collection('timeline').doc(followerId).collection('timelinePosts').doc(postId).set(postCreated);
        });



    });


exports.onUpdatePost = functions.firestore.document('/posts/{userId}/userPosts/{postId}').onUpdate(
    async (change, context) => {
        const postUpdated = change.after.data();
        const userId = context.params.userId;
        const postId = context.params.postId;

        const userFollowersRef = admin.firestore().collection('followers').doc(userId).collection('userFollowers');

        const querySnapshot = await userFollowersRef.get();


        //2) update  new post to each follower's timeline
        querySnapshot.forEach(doc => {
            const followerId = doc.id;

            admin.firestore().collection('timeline').doc(followerId).collection('timelinePosts').doc(postId).get().then(doc => {

                if (doc.exists) {
                    doc.ref.update(postUpdated);
                }
            });
        });



    });



exports.onDeletePost = functions.firestore.document('/posts/{userId}/userPosts/{postId}').onDelete(
    async (change, context) => {
        const userId = context.params.userId;
        const postId = context.params.postId;
        const userFollowersRef = admin.firestore().collection('followers').doc(userId).collection('userFollowers');

        const querySnapshot = await userFollowersRef.get();


        //2) delete  new post to each follower's timeline
        querySnapshot.forEach(doc => {
            const followerId = doc.id;

            admin.firestore().collection('timeline').doc(followerId).collection('timelinePosts').doc(postId).get().then(doc => {

                if (doc.exists) {
                    doc.ref.delete();
                }
            });
        });



    });


//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//local Timeline
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------



//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Activity Feed
//------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------


exports.onCreateActivityFeedItem = functions.firestore.document('/feed/{userId}/feedItems/{activityFeedItem}').onCreate(
    async (snapshot, context)=> {
        console.log('Actvity Feed Item Created', snapshot.data());

        //1) get user connected to the feed
        const userId = context.params.userId;
        const userRef = admin.firestore().doc(`users/${userId}`);
        const doc = await userRef.get();

        //2) once we have user, check if they have notification token
        const androidNotificationToken = doc.data().androidNotificationToken;
        const createdActivityFeedItem = snapshot.data();
        if (androidNotificationToken){
            //send notifciation
            sendNotification(androidNotificationToken,createdActivityFeedItem)
        }else{
            console.log("No token for user, cannot send notification")
        }


        function sendNotification(androidNotificationToken, activityFeedItem){
            let body;

            //switch body vlaue based off on notification type

            switch (activityFeedItem.type) {

                case "Cash":
                    body = `${activityFeedItem.username} bid your item with \$: ${activityFeedItem.item}`;
                    break;

                case "Item":
                    body = `${activityFeedItem.username} barter with : ${activityFeedItem.item}`;
                    break;


                case "comment":
                    body = `${activityFeedItem.username} replied : ${activityFeedItem.commentData}`;
                    break;

                case "like":
                    body = `${activityFeedItem.username} liked your post`;
                    break;     

                case "follow":
                    body = `${activityFeedItem.username} started following you`;
                    break;                         
                default:
                    break;
            }


            //4) creat message for push notification
            const message ={
                notification: {body},
                token: androidNotificationToken,
                data:{recipient: userId},

            };

            //5) send message with admin.messaging
            admin.messaging().send(message).then(
                Response=>{
                    console.log("Successfully sent message",Response);
                }
            )
            .catch(error =>{
                console.log("Error sensing message",error);
            })
        }

    }
)
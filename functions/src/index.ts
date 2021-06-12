import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
  .document('generalNotifyStudents/{generalNotifyId}')
  .onCreate(async snapshot => {
    if(!snapshot.exists){
      console.log('No devices');
      return ;
    }
    const tokens = [] as  any;
    var classForGen = [];
    const newGenNotify = snapshot.data();
    console.log('newGenNotify ',newGenNotify);
    for(var i=0;i<newGenNotify.classID.length;i++){
      classForGen.push(newGenNotify.classID[i]);
    }
    console.log('classForGen ',classForGen);
    const studentDetails = await admin.firestore().collection('students').get();
    for(var j=0;j<classForGen.length;j++){
      for( var stuClass of studentDetails.docs){
        const classID = stuClass.get('classID');
        console.log('classID ',classID);
        console.log('classForGen[j] ',classForGen[j]);
        if(classID  == classForGen[j]){
          var stuDocID = stuClass.id;
          console.log(stuDocID);
          const querySnapshot = await db
          .collection('students')
          .doc(stuDocID)
          .collection('tokens')
          .get();
          console.log(querySnapshot);
          const deviceToken = querySnapshot.docs.map(snap => snap.id);
          console.log('deviceToken ',deviceToken);
            for(var k=0;k<deviceToken.length;k++){
              tokens.push(deviceToken[k]);
            }
        }
      }
    }

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: `${newGenNotify.department} SEM ${newGenNotify.semester} - ${newGenNotify.messageTitle}`,
          body: `${newGenNotify.message}`,
          // icon: 'your-icon-url',
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      };
      console.log('Final tokens', tokens);
      return fcm.sendToDevice(tokens, payload);
  });


  export const backlogNotify = functions.firestore
  .document('notifyStudents/{notifyStudentsId}')
  .onCreate(async snapshot => {
    if(!snapshot.exists){
      console.log('No devices');
      return ;
    }
    const backlogtokens = [] as  any;
    var classForBacklog = [];
    var subjectBacklog = [];
    const newBacklogNotify = snapshot.data();
    console.log('newBacklogNotify ',newBacklogNotify);
    for(var l=0;l<newBacklogNotify.classID.length;l++){
      classForBacklog.push(newBacklogNotify.classID[l]);
    }
    for(var m=0;m<newBacklogNotify.backlogsubs.length;m++){
      subjectBacklog.push(newBacklogNotify.backlogsubs[m]);
    }
    console.log('classForBacklog ',classForBacklog);
    console.log('subjectForBacklog ',subjectBacklog);
    const studentDetails = await admin.firestore().collection('students').get();
    for(var n=0;n<classForBacklog.length;n++){
      for( var stuClass of studentDetails.docs){
        const classID = stuClass.get('classID');
        console.log('classID ',classID);
        console.log('classForBacklog[n] ',classForBacklog[n]);
        if(classID  == classForBacklog[n]){
            // for(var stuBacklog of studentDetails.docs){}
              const stuBackLogSubs = stuClass.get('backlogsubs');
              for(var p=0;p<subjectBacklog.length;p++){
                for(var q=0;q<stuBackLogSubs.length;q++){
                  if(stuBackLogSubs[q]==subjectBacklog[p]){
                    var stuDocID = stuClass.id;
                    console.log(stuDocID);
                    const querySnapshot = await db
                    .collection('students')
                    .doc(stuDocID)
                    .collection('tokens')
                    .get();
                    console.log(querySnapshot);
                    const deviceToken = querySnapshot.docs.map(snap => snap.id);
                    console.log('deviceToken ',deviceToken);
                      for(var r=0;r<deviceToken.length;r++){
                        backlogtokens.push(deviceToken[r]);
                      }
                  }
                }
              }
        }
      }
    }

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: `${newBacklogNotify.email} `,
          body: `${newBacklogNotify.message} - SUB ${newBacklogNotify.backlogsubs}`,
          // icon: 'your-icon-url',
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      };
      console.log('Final Backlog tokens', backlogtokens);
      return fcm.sendToDevice(backlogtokens, payload);
  });


  export const ODProvideNotify = functions.firestore
  .document('odRequests/{odRequestsId}')
  .onCreate(async snapshot => {
    if(!snapshot.exists){
      console.log('No devices');
      return ;
    }
    const Stafftokens = [] as  any;
    const OdRequests = snapshot.data();
    console.log('OdRequests ',OdRequests);
    const staffDetails = await admin.firestore().collection('staffs').get();
      for( var staffDep of staffDetails.docs){
        const staffDepartment = staffDep.get('department');
        console.log('staffDepartment ',staffDepartment);
        if(staffDepartment  == OdRequests.department){
          var staffDocID = staffDep.id;
          console.log(staffDocID);
          const querySnapshot = await db
          .collection('staffs')
          .doc(staffDocID)
          .collection('tokens')
          .get();
          console.log(querySnapshot);
          const deviceToken = querySnapshot.docs.map(snap => snap.id);
          console.log('deviceToken ',deviceToken);
            for(var k=0;k<deviceToken.length;k++){
              Stafftokens.push(deviceToken[k]);
            }
        }
      }


      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: `${OdRequests.classID} - ${OdRequests.email}`,
          body: `${OdRequests.date} for event ${OdRequests.eventTitle}`,
          // icon: 'your-icon-url',
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      };
      console.log('Final tokens', Stafftokens);
      return fcm.sendToDevice(Stafftokens, payload);
  });
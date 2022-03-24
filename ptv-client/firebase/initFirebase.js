import { initializeApp } from "firebase/app";
import { GeoPoint, getFirestore} from "firebase/firestore";


// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBXIMz-MaEW_tSmXRCHHGlWDHA6ABXmbyU",
  authDomain: "ptvhack22.firebaseapp.com",
  projectId: "ptvhack22",
  storageBucket: "ptvhack22.appspot.com",
  messagingSenderId: "230270217194",
  appId: "1:230270217194:web:4915426cb955d00a972093",
  measurementId: "G-BL0VNN8PHR"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export { app, db, GeoPoint };
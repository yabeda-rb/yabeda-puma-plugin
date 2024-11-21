import http from 'k6/http';
export const options = {
  stages: [
//    { duration: '30s', target: 1000 },
    { duration: '300s', target: 3000 },
//    { duration: '10s', target: 750 },
//    { duration: '10s', target: 500 },
//    { duration: '10s', target: 0 },
  ],
};


export default function () {
  for (let id = 1; id <= 100; id++) {
    http.get("http://app:9292/");
  }
}

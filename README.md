## Running:
1. Clone the repo:
  ```
  git clone https://github.com/agufranov/accountant.git
  ```

2. Install dependencies:
  ```
  npm install
  bower install
  ```
3. Build Ionic SASS:
  ```
  gulp ionic-sass
  ```

4. To run in browser (will start development server with watch, compile & livereload):
  ```
  gulp serve
  ```
  To run as Ionic app:
  ```
  gulp build
  ```
  or
  ```
  gulp serve
  ```
  and then run it with Ionic CLI (for details, see [Ionic docs](http://ionicframework.com/docs/cli/run.html)).
  For example, running on Android device:
  ```
  ionic platform android
  ionic run
  ```

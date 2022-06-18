
<h1 align="center">
  <img src="https://raw.githubusercontent.com/jerichoi224/WorkoutTracker/main/assets/feature.png?token=GHSAT0AAAAAABUY76HR2WPQPZIJO7WUA3JQYVNUVZQ" width="600">
</h1>

Application for Tracking Workouts, made with Flutter.
[Available in Google Play Store](https://play.google.com/store/apps/details?id=com.kahluabear.workout_tracker)

### Development Status
I've added everything I wanted to add for my personal need which includes the functions and support for English and Korean Language. If requested and with some help on translations, I can add more languages, but unless I come up with more ideas on functionalities or find bugs while using it, the development will be on pause for now. 

## Basic Overview
The basic function is to keep track of workout sessions, and see how you progress in terms of weights/workouts

### Functionality
<p float="left">
  <img src="https://raw.githubusercontent.com/jerichoi224/WorkoutTracker/main/assets/1.png" width="250">
  <img src="https://raw.githubusercontent.com/jerichoi224/WorkoutTracker/main/assets/2.png" width="250">
  <img src="https://raw.githubusercontent.com/jerichoi224/WorkoutTracker/main/assets/6.png" width="250">
</p>
The three screenshots above show the basic functionality of the app.</br>
The Dashboard screen shows you your workouts so far in the month, and options to start a new session/routine. </br>
The second screen shows you how the "Add Session" Screen looks. Once done, the third screen shows you the overview of the workout session

<p float="left">
  <img src="https://raw.githubusercontent.com/jerichoi224/WorkoutTracker/main/assets/3.png" width="250">
  <img src="https://raw.githubusercontent.com/jerichoi224/WorkoutTracker/main/assets/4.png" width="250">
  <img src="https://raw.githubusercontent.com/jerichoi224/WorkoutTracker/main/assets/5.png" width="250">
</p>

As you add multiple sessions, you can see how you're max/avg weight of the specific workout changes over time </br>
Routines are just a group of workouts, where you can group and the "Add Session" screen will be pre-populated if you decide to choose "Start Routine"</br>
You can also see the previous workout sessions through the calendar view too

### Other Info

This App is honestly much better than my previous app money tracker in terms of function and quality in my opinion. I used Objectbox for Database instead of sfqlite. 

### Open Source!

While this app is open source, I use resources/libraries that are non-MIT. So first let me leave this here first. </br>
BSD_3</br>
Copyright 2013, the Dart project authors. All rights reserved. Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met: </br>
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. </br>
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution. </br>
* Neither the name of Google Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.</br></br>
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT IMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Also, I use the chart library from Syncfusion. Check their license [here](https://pub.dev/packages/syncfusion_flutter_charts/license) </br>
Basically, you can use the library if:
* Your gross revenue of less than one (1) million U.S. dollars ($1,000,000.00 USD) per year
* You have less than five (5) developers in your organization
* You agree to be bound by Syncfusion’s terms and conditions. 

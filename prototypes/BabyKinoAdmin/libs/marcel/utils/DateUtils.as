/**
 * Licensed under the MIT License
 *
 * Copyright (c) 2010 Alexandre Croiseaux
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */
package marcel.utils {

	/**
	 * 	Class that contains static utility methods for manipulating and working
	 *	with Dates.
	 * @author Alexandre Croiseaux
	 */
	public class DateUtils {
		/**
		 * Returns the age in years from a birth date
		 * @param	birthdate	the date to start from
		 * @return	the completed years
		 */
		public static function getAge(birthdate:Date):Number {
			var dtNow:Date = new Date();
			// gets current date
			var currentMonth:Number = dtNow.getMonth();
			var currentDay:Number = dtNow.getDay();
			var currentYear:Number = dtNow.getFullYear();
			var bdMonth:Number = birthdate.getMonth();
			var bdDay:Number = birthdate.getDay();
			var bdYear:Number = birthdate.getFullYear();
			// get the difference in years
			var years:Number = dtNow.getFullYear() - birthdate.getFullYear();
			// subtract another year if we're before the
			// birth day in the current year
			if (currentMonth < bdMonth || (currentMonth == bdMonth && currentDay < bdDay)) {
				years--;
			}
			return years;
		}

		/**
		 * Returns a date object from a string
		 * @param	dateString	the string to start from (format DD/MM/YYYY)
		 * @param	delimiter	the string delimiter, default '/'
		 * @return	a Date instance
		 */
		public static function getDateFromString(dateString:String, delimiter:String = "/"):Date {
			var aDate:Array = dateString.split("/");
			return new Date(aDate[2], aDate[1] - 1, aDate[0]);
		}

		/**
		 * Retrusn a Date object from a MySQL Date or DateTime string (format 2008-08-04 or 2008-08-04 13:47:35)
		 * @param	dateString	the string to start from (format 2008-08-04 or 2008-08-04 13:47:35)
		 * @return	a Date instance
		 */
		public static function getDateFromSQLDate(dateString:String, dateTimeSeparator:String = " "):Date {
			if (dateString.indexOf("+") > -1) dateString = dateString.split("+").shift();
			var date:Date = new Date();
			var aDate:Array = dateString.split(dateTimeSeparator).shift().split("-");
			date.fullYear = Number(aDate[0]);
			date.month = Number(aDate[1]) - 1;
			date.date = Number(aDate[2]);
			
			var aTime:Array = dateString.split(dateTimeSeparator).pop().split(":");
			if (aTime.length > 0) {
				date.hours = Number(aTime[0]);
				date.minutes = Number(aTime[1]);
				date.seconds = Number(aTime[2]);
			}
			
			return date;
		}

		/**
		 * Return true if the year  is bisextile
		 * @param	year	the year (aaaa)
		 * @return	a Boolean
		 */
		static public function isBisextile(year:Number):Boolean {
			return (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0));
		}

		/**
		 * Return a string formated
		 * @param	time	date time in ms
		 * @param 	format	String for the format. we use php date syntax ex: y-m-d : 2004-05-01
		 * @return	a String
		 */
		static public function date(time:Number, format:String):String {
			var oDate:Date = new Date();
			oDate.setTime(time * 1000);
			var Y:Number = oDate.getFullYear();
			var m:Number = (oDate.getMonth() + 1);
			var M:String = ((m < 10 ? "0" : "") + m) as String;
			var d:Number = oDate.getDate();
			var D:String = ((d < 10 ? "0" : "") + d) as String;
			var h:Number = oDate.getHours() - 1;
			if (h == -1) h = 23;
			var H:String = ((h < 10 ? "0" : "") + h) as String;
			var i:Number = oDate.getMinutes();
			var I:String = ((i < 10 ? "0" : "") + i) as String;
			var s:Number = oDate.getSeconds();
			var S:String = ((s < 10 ? "0" : "") + s) as String;
			
			var out:String = format;
			out = out.replace(/Y/, Y);
			out = out.replace(/m/, m);
			out = out.replace(/M/, M);
			out = out.replace(/d/, d);
			out = out.replace(/D/, D);
			out = out.replace(/H/, H);
			out = out.replace(/i/, i);
			out = out.replace(/I/, I);
			out = out.replace(/s/, s);
			out = out.replace(/S/, S);
			return out;
		}

		/**
		 * Returns the number of the calendar week from a date.
		 * @param day		the day to find the week from, if NaN, the current day is used.
		 * @param month		the month to find the week from, if NaN, the current month is used.
		 * @param year		the year to find the week from, if NaN, the current year is used.
		 * @return number of week
		 */
		static public function getWeek(day:Number = NaN, month:Number = NaN, year:Number = NaN):uint {
			var d:Date = new Date();
			if (isNaN(day)) day = d.getDate();
			if (isNaN(month)) month = d.getMonth();
			if (isNaN(year)) year = d.getFullYear();
			
			var aS:Number = Math.floor((14 - month + 1) / 12);
			var yS:Number = year + 4800 - aS;
			var mS:Number = (month + 1) + 12 * aS - 3;
			var JS:Number = day + Math.floor((153 * mS + 2) / 5) + yS * 365 + Math.floor(yS / 4) - Math.floor(yS / 100) + Math.floor(yS / 400) - 32045;
			var d4:Number = (((JS + 31741 - (JS % 7)) % 146097) % 36524) % 1461;
			var L:Number = Math.floor(d4 / 1460);
			var d1:Number = ((d4 - L) % 365) + L;
			return Math.floor(d1 / 7) + 1;
		}

		/**
		 * Return the date of the first date of this week, Start week is Monday
		 * @param week number of the week
		 * @param year the year
		 * @return Date
		 */
		static public function getDateFromWeek(week:Number = NaN, year:Number = NaN):Date {
			if (isNaN(week)) week = getWeek();
			if (isNaN(year)) year = new Date().getFullYear();
			var joursem:Number = new Date(year, 0, 1).getDay();
			joursem = joursem > 4 ? joursem - 7 : joursem;
			var dateLundi:Date = new Date(year, 0, 1);
			dateLundi.setDate(((week - 1) * 7) - joursem + 2);
			return dateLundi;
		}
	}
}

/**
 * Licensed under the MIT License
 *
 * Copyright (c) 2010 Benoit Saint Maxent
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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;	

	/**
	 *  @author Benoit Saint Maxent  
	 */
	public class PrintUtils extends Object {
		
		private static var _aPrintedDos : Array;

		public static function queueDisplayObject(do_ : DisplayObject, oArea : Rectangle = null, bEnableWidening : Boolean = false, nMarginMinPerc : Number = .1, bDisposeAfterPrint : Boolean = true) : void {
			if(!_aPrintedDos) _aPrintedDos = new Array();
			
			var doPrinted : Sprite = new Sprite();
			
			if((!oArea) && (do_ is Bitmap)) {
				doPrinted.addChild(do_);
				_aPrintedDos.push({doPrinted:doPrinted, nMarginMinPerc:nMarginMinPerc, bEnableWidening:bEnableWidening, bDisposeAfterPrint:bDisposeAfterPrint});
				return;
			}
			
			oArea = oArea ? oArea : new Rectangle(0, 0, do_.width, do_.height);
			
			var bd : BitmapData = new BitmapData(oArea.width, oArea.height, false, 0xffffff);
			var m : Matrix = new Matrix();
			m.translate(-oArea.x, -oArea.y);
			bd.draw(do_, m, null, null, new Rectangle(0, 0, oArea.width, oArea.height));
			var bmp : Bitmap = new Bitmap(bd, PixelSnapping.AUTO, true);
			
			doPrinted.addChild(bmp);
			
			_aPrintedDos.push({doPrinted:doPrinted, nMarginMinPerc:nMarginMinPerc, bEnableWidening:bEnableWidening, bDisposeAfterPrint:bDisposeAfterPrint});

		}

		public static function printQueue() : void {
			if(!_aPrintedDos) return;
			if(_aPrintedDos.length < 1) {
				_aPrintedDos = null;
				return;
			}
			var pj : PrintJob = new PrintJob();
			if(!pj.start()) return;
			
			var nPages : int = _aPrintedDos.length;
			var nPrintedNum : int = 0;
			for (var i : int; i < nPages; i++) {
				var doPrinted : Sprite = _aPrintedDos[i].doPrinted;
				var nMarginMinPerc : Number = _aPrintedDos[i].nMarginMinPerc;
				var bEnableWidening : Boolean = _aPrintedDos[i].bEnableWidening;
				var bmp : Bitmap = doPrinted.getChildAt(0) as Bitmap;
				var bd : BitmapData = bmp.bitmapData;
				var nSafeAreaCoeff : Number = 1 - nMarginMinPerc;
				var nScale : Number = (nSafeAreaCoeff * pj.pageWidth) / bmp.width;
				if(bmp.height * nScale > (nSafeAreaCoeff * pj.pageHeight)) nScale = (nSafeAreaCoeff * pj.pageHeight) / bmp.height;
				if(!bEnableWidening) nScale = Math.min(1, nScale);
				bmp.scaleX = bmp.scaleY = nScale;
				
				bmp.x = Math.round((pj.pageWidth - bmp.width) * .5);
				bmp.y = Math.round((pj.pageHeight - bmp.height) * .5);
				
				with(doPrinted.graphics) {
					beginFill(0xffffff);
					drawRect(0, 0, pj.pageWidth, pj.pageHeight);
				}
				
				try {
					doPrinted.cacheAsBitmap = true;
					pj.addPage(doPrinted/*, null, new PrintJobOptions(true)*/);
					nPrintedNum++;
				} catch(e : Error) {}
				bmp.scaleX = bmp.scaleY = 1;
				bmp.x = bmp.y = 0;
				if(_aPrintedDos[i].bDisposeAfterPrint) bd.dispose();
			}
			
			_aPrintedDos = null;
			if(nPrintedNum > 0) pj.send();
		}

		
		public static function printDisplayObjectsAsBitmaps(aDOs : /*DisplayObject*/Array, aPrintAreas : /*Rectangle*/Array = null, bEnableWidening : Boolean = false, nMarginMinPerc : Number = .1, bDisposeAfterPrint : Boolean = true) : void {
			var bIsInitEmpty : Boolean = !aPrintAreas || aPrintAreas.length == 0;
			for (var i: int = 0; i< aDOs.length; i++) {
				var do_ : DisplayObject = aDOs[i];
				var oPrintArea : Rectangle = bIsInitEmpty ? new Rectangle(0, 0, do_.width, do_.height) : aPrintAreas[i];
				queueDisplayObject(do_, oPrintArea, bEnableWidening, nMarginMinPerc, bDisposeAfterPrint);
			}
			printQueue();
		}
		
	}
}

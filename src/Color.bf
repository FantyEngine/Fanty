using System;

namespace FantyEngine;

public typealias byte = uint8;

public struct Color
{
	/// Red component of the color.
	public byte r;
	/// Green component of the color.
	public byte g;
	/// Green component of the color.
	public byte b;
	/// Alpha component of the color.
	public byte a;

	/// Constructs a Color with given r, g, b, and a components.
	public this(byte r, byte g, byte b, byte a)
	{
		this.r = r; this.g = g; this.b = b; this.a = a;
	}

	/// Constructs a Color with given r, g, b components and sets a to 255.
	public this(byte r, byte g, byte b)
	{
		this.r = r; this.g = g; this.b = b; this.a = 255;
	}

	public this(uint packedValue)
	{
		this.r = (byte)packedValue;
		this.g = (byte)(packedValue >> 8);
		this.b = (byte)(packedValue >> 16);
		this.a = (byte)(packedValue >> 24);
	}

	/// Constructs a Color with given HEX
	public this(System.StringView hexC)
	{
		var hex = scope String(hexC);

		hex.Replace("0x", ""); // in case the string is formatted 0xFFFFFF
		hex.Replace("#", ""); // in case the string is formatted #FFFFFF
		uint8 a = uint8.MaxValue; // assume fully visible unless specified in hex
		uint8 r = uint8.Parse(hex.Substring(0, 2), .AllowLeadingWhite | .AllowTrailingWhite | .Hex);
		uint8 g = uint8.Parse(hex.Substring(2, 2), .AllowLeadingWhite | .AllowTrailingWhite | .Hex);
		uint8 b = uint8.Parse(hex.Substring(4, 2), .AllowLeadingWhite | .AllowTrailingWhite | .Hex);
		// Only use alpha if the string has enough characters
		if (hex.Length == 8)
		{
			a = uint8.Parse(hex.Substring(6, 2), .AllowLeadingWhite | .AllowTrailingWhite | .Hex);
		}
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}

	/// Convert a color from RGB to HSV color space.
	public static void RGBToHSV(Color rgbCol, out float H, out float S, out float V)
	{
		// when blue is highest valued
		if ((rgbCol.b > rgbCol.g) && (rgbCol.b > rgbCol.r))
			RGBToHSVHelper((float)4, rgbCol.b, rgbCol.r, rgbCol.g, out H, out S, out V);
		//when green is highest valued
		else if (rgbCol.g > rgbCol.r)
			RGBToHSVHelper((float)2, rgbCol.g, rgbCol.b, rgbCol.r, out H, out S, out V);
		//when red is highest valued
		else
			RGBToHSVHelper((float)0, rgbCol.r, rgbCol.g, rgbCol.b, out H, out S, out V);
	}

	private static void RGBToHSVHelper(float offset, float dominantcolor, float colorone, float colortwo, out float H, out float S, out float V)
	{
		V = dominantcolor;
		// We need to find out which is the minimum color
		if (V != 0)
		{
			//we check which color is smallest
			float small = 0;
			if (colorone > colortwo) small = colortwo;
			else small = colorone;

			float diff = V - small;

			// If the two values are not the same, we compute the like this
			if (diff != 0)
			{
				// S = max-min/max
				S = diff / V;
				// H = hue is offset by X, and is the difference between the two smallest colors
				H = offset + ((colorone - colortwo) / diff);
			}
			else
			{
				// S = 0 when the difference is zero
				S = 0;
				// H = 4 + (R-G) hue is offset by 4 when blue, and is the difference between the two smallest colors
				H = offset + (colorone - colortwo);
			}

			H /= 6;

			// Conversion values
			if (H < 0)
				H += 1.0f;
		}
		else
		{
			S = 0;
			H = 0;
		}
	}

	/*
	public static Color HSVToRGB(float H, float S, float V)
	{
		return HSVToRGB(H, S, V, true);
	}

	/// Convert a set of HSV values to an RGB Color.
	public static Color HSVToRGB(float H, float S, float V, bool hdr)
	{
		Color retval = Color.white;
		if (S == 0)
		{
			retval.r = V;
			retval.g = V;
			retval.b = V;
		}
		else if (V == 0)
		{
			retval.r = 0;
			retval.g = 0;
			retval.b = 0;
		}
		else
		{
			retval.r = 0;
			retval.g = 0;
			retval.b = 0;

			// Crazy hsv conversion
			float t_S, t_V, h_to_floor;

			t_S = S;
			t_V = V;
			h_to_floor = H * 6.0f;

			int temp = (int)Mathf.Floor(h_to_floor);
			float t = h_to_floor - ((float)temp);
			float var_1 = (t_V) * (1 - t_S);
			float var_2 = t_V * (1 - t_S * t);
			float var_3 = t_V * (1 - t_S * (1 - t));

			switch (temp)
			{
				case 0:
					retval.r = t_V;
					retval.g = var_3;
					retval.b = var_1;
					break;

				case 1:
					retval.r = var_2;
					retval.g = t_V;
					retval.b = var_1;
					break;

				case 2:
					retval.r = var_1;
					retval.g = t_V;
					retval.b = var_3;
					break;

				case 3:
					retval.r = var_1;
					retval.g = var_2;
					retval.b = t_V;
					break;

				case 4:
					retval.r = var_3;
					retval.g = var_1;
					retval.b = t_V;
					break;

				case 5:
					retval.r = t_V;
					retval.g = var_1;
					retval.b = var_2;
					break;

				case 6:
					retval.r = t_V;
					retval.g = var_3;
					retval.b = var_1;
					break;

				case -1:
					retval.r = t_V;
					retval.g = var_1;
					retval.b = var_2;
					break;
			}

			if (!hdr)
			{
				retval.r = Mathf.Clamp(retval.r, 0.0f, 1.0f);
				retval.g = Mathf.Clamp(retval.g, 0.0f, 1.0f);
				retval.b = Mathf.Clamp(retval.b, 0.0f, 1.0f);
			}
		}
		return retval;
	}
	*/

	/// Interpolates between colors a and b by t.
	public static Color Lerp(Color a, Color b, float t)
	{
		var t;
		t = Math.Clamp(t, 0, 1);
		return Color(
			 (byte)((a.r + (b.r - a.r) * t) * 255),
			 (byte)((a.g + (b.g - a.g) * t) * 255),
			 (byte)((a.b + (b.b - a.b) * t) * 255),
			 (byte)((a.a + (b.a - a.a) * t) * 255)
		 );
	}

	public Color ChangeAlpha(byte param)
	{
		return Color(r, g, b, param);
	}

	public static implicit operator uint32(Color color)
	{
		return (uint32)(((int)color.a << 24) | ((int)color.b << 16) |
			((int)color.g << 8) | ((int)color.r << 0));
	}

	public static implicit operator RaylibBeef.Color(Color color)
	{
		return .(color.r, color.g, color.b, color.a);
	}

	public static Color transparent = Color(0);
	public static Color aliceBlue = Color(0xfffff8f0);
	public static Color antiqueWhite = Color(0xffd7ebfa);
	public static Color aqua = Color(0xffffff00);
	public static Color aquamarine = Color(0xffd4ff7f);
	public static Color azure = Color(0xfffffff0);
	public static Color beige = Color(0xffdcf5f5);
	public static Color bisque = Color(0xffc4e4ff);
	public static Color black = Color(0xff000000);
	public static Color blanchedAlmond = Color(0xffcdebff);
	public static Color blue = Color(0xffff0000);
	public static Color blueViolet = Color(0xffe22b8a);
	public static Color brown = Color(0xff2a2aa5);
	public static Color burlyWood = Color(0xff87b8de);
	public static Color cadetBlue = Color(0xffa09e5f);
	public static Color chartreuse = Color(0xff00ff7f);
	public static Color chocolate = Color(0xff1e69d2);
	public static Color coral = Color(0xff507fff);
	public static Color cornflowerBlue = Color(0xffed9564);
	public static Color cornsilk = Color(0xffdcf8ff);
	public static Color crimson = Color(0xff3c14dc);
	public static Color cyan = Color(0xffffff00);
	public static Color darkBlue = Color(0xff8b0000);
	public static Color darkCyan = Color(0xff8b8b00);
	public static Color darkGoldenrod = Color(0xff0b86b8);
	public static Color darkGray = Color(35, 35, 35, 255);
	public static Color darkGreen = Color(0xff006400);
	public static Color darkKhaki = Color(0xff6bb7bd);
	public static Color darkMagenta = Color(0xff8b008b);
	public static Color darkOliveGreen = Color(0xff2f6b55);
	public static Color darkOrange = Color(0xff008cff);
	public static Color darkOrchid = Color(0xffcc3299);
	public static Color darkRed = Color(0xff00008b);
	public static Color darkSalmon = Color(0xff7a96e9);
	public static Color darkSeaGreen = Color(0xff8bbc8f);
	public static Color darkSlateBlue = Color(0xff8b3d48);
	public static Color darkSlateGray = Color(0xff4f4f2f);
	public static Color darkTurquoise = Color(0xffd1ce00);
	public static Color darkViolet = Color(0xffd30094);
	public static Color deepPink = Color(0xff9314ff);
	public static Color deepSkyBlue = Color(0xffffbf00);
	public static Color dimGray = Color(0xff696969);
	public static Color dodgerBlue = Color(0xffff901e);
	public static Color firebrick = Color(0xff2222b2);
	public static Color floralWhite = Color(0xfff0faff);
	public static Color forestGreen = Color(0xff228b22);
	public static Color fuchsia = Color(0xffff00ff);
	public static Color gainsboro = Color(0xffdcdcdc);
	public static Color ghostWhite = Color(0xfffff8f8);
	public static Color gold = Color(0xff00d7ff);
	public static Color goldenrod = Color(0xff20a5da);
	public static Color gray = Color(0xff808080);
	public static Color green = Color(0xff008000);
	public static Color greenYellow = Color(0xff2fffad);
	public static Color honeydew = Color(0xfff0fff0);
	public static Color hotPink = Color(0xffb469ff);
	public static Color indianRed = Color(0xff5c5ccd);
	public static Color indigo = Color(0xff82004b);
	public static Color ivory = Color(0xfff0ffff);
	public static Color khaki = Color(0xff8ce6f0);
	public static Color lavender = Color(0xfffae6e6);
	public static Color lavenderBlush = Color(0xfff5f0ff);
	public static Color lawnGreen = Color(0xff00fc7c);
	public static Color lemonChiffon = Color(0xffcdfaff);
	public static Color lightBlue = Color(0xffe6d8ad);
	public static Color lightCoral = Color(0xff8080f0);
	public static Color lightCyan = Color(0xffffffe0);
	public static Color lightGoldenrodYellow = Color(0xffd2fafa);
	public static Color lightGray = Color(0xffd3d3d3);
	public static Color lightGreen = Color(0xff90ee90);
	public static Color lightPink = Color(0xffc1b6ff);
	public static Color lightSalmon = Color(0xff7aa0ff);
	public static Color lightSeaGreen = Color(0xffaab220);
	public static Color lightSkyBlue = Color(0xffface87);
	public static Color lightSlateGray = Color(0xff998877);
	public static Color lightSteelBlue = Color(0xffdec4b0);
	public static Color lightYellow = Color(0xffe0ffff);
	public static Color lime = Color(0xff00ff00);
	public static Color limeGreen = Color(0xff32cd32);
	public static Color linen = Color(0xffe6f0fa);
	public static Color magenta = Color(0xffff00ff);
	public static Color maroon = Color(0xff000080);
	public static Color mediumAquamarine = Color(0xffaacd66);
	public static Color mediumBlue = Color(0xffcd0000);
	public static Color mediumOrchid = Color(0xffd355ba);
	public static Color mediumPurple = Color(0xffdb7093);
	public static Color mediumSeaGreen = Color(0xff71b33c);
	public static Color mediumSlateBlue = Color(0xffee687b);
	public static Color mediumSpringGreen = Color(0xff9afa00);
	public static Color mediumTurquoise = Color(0xffccd148);
	public static Color mediumVioletRed = Color(0xff8515c7);
	public static Color midnightBlue = Color(0xff701919);
	public static Color mintCream = Color(0xfffafff5);
	public static Color mistyRose = Color(0xffe1e4ff);
	public static Color moccasin = Color(0xffb5e4ff);
	public static Color monoGameOrange = Color(0xff003ce7);
	public static Color navajoWhite = Color(0xffaddeff);
	public static Color navy = Color(0xff800000);
	public static Color oldLace = Color(0xffe6f5fd);
	public static Color olive = Color(0xff008080);
	public static Color oliveDrab = Color(0xff238e6b);
	public static Color orange = Color(0xff00a5ff);
	public static Color orangeRed = Color(0xff0045ff);
	public static Color orchid = Color(0xffd670da);
	public static Color paleGoldenrod = Color(0xffaae8ee);
	public static Color paleGreen = Color(0xff98fb98);
	public static Color paleTurquoise = Color(0xffeeeeaf);
	public static Color paleVioletRed = Color(0xff9370db);
	public static Color papayaWhip = Color(0xffd5efff);
	public static Color peachPuff = Color(0xffb9daff);
	public static Color peru = Color(0xff3f85cd);
	public static Color pink = Color(0xffcbc0ff);
	public static Color plum = Color(0xffdda0dd);
	public static Color powderBlue = Color(0xffe6e0b0);
	public static Color purple = Color(0xff800080);
	public static Color red = Color(0xff0000ff);
	public static Color rosyBrown = Color(0xff8f8fbc);
	public static Color royalBlue = Color(0xffe16941);
	public static Color saddleBrown = Color(0xff13458b);
	public static Color salmon = Color(0xff7280fa);
	public static Color sandyBrown = Color(0xff60a4f4);
	public static Color seaGreen = Color(0xff578b2e);
	public static Color seaShell = Color(0xffeef5ff);
	public static Color sienna = Color(0xff2d52a0);
	public static Color silver = Color(0xffc0c0c0);
	public static Color skyBlue = Color(0xffebce87);
	public static Color slateBlue = Color(0xffcd5a6a);
	public static Color slateGray = Color(0xff908070);
	public static Color snow = Color(0xfffafaff);
	public static Color springGreen = Color(0xff7fff00);
	public static Color steelBlue = Color(0xffb48246);
	public static Color tan = Color(0xff8cb4d2);
	public static Color teal = Color(0xff808000);
	public static Color thistle = Color(0xffd8bfd8);
	public static Color tomato = Color(0xff4763ff);
	public static Color turquoise = Color(0xffd0e040);
	public static Color violet = Color(0xffee82ee);
	public static Color wheat = Color(0xffb3def5);
	public static Color white = Color(uint.MaxValue);
	public static Color whiteSmoke = Color(0xfff5f5f5);
	public static Color yellow = Color(0xff00ffff);
	public static Color yellowGreen = Color(0xff32cd9a);
	public static Color trinkit => Color("407e8d");
	public static Color unity => Color("314D79");
	public static Color bgfx => Color("443355");
}
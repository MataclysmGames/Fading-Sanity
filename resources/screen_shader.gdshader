/*
Shader from Godot Shaders - the free shader library.
godotshaders.com/shader/VHS-and-CRT-monitor-effect

This shader is under CC0 license. Feel free to use, improve and 
change this shader according to your needs and consider sharing 
the modified result to godotshaders.com.
*/

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 resolution = vec2(640.0, 360.0); // Set the number of rows and columns the texture will be divided in. Scanlines and grille will make a square based on these values

uniform bool pixelate = false; // Fill each square ("pixel") with a sampled color, creating a pixel look and a more accurate representation of how a CRT monitor would work.

uniform float aberration : hint_range(-1.0, 1.0) = 0.00; // Chromatic aberration, a distortion on each color channel.
uniform float aberration_vert : hint_range(-1.0, 1.0) = 0.00; // Chromatic aberration, a distortion on each color channel.

void fragment()
{
	vec2 text_uv = UV;
	
	// Pixelate the texture based on the given resolution.
	if (pixelate)
	{
		text_uv = ceil(UV * resolution) / resolution;
	}
	
	vec4 text;
	
	// If roll is false only apply the aberration without any distorion. The aberration values are very small so the .1 is only 
	// to make the slider in the Inspector less sensitive.
	text.r = texture(SCREEN_TEXTURE, text_uv + vec2(aberration, aberration_vert) * .1).r;
	text.g = texture(SCREEN_TEXTURE, text_uv - vec2(aberration, aberration_vert) * .1).g;
	text.b = texture(SCREEN_TEXTURE, text_uv).b;
	text.a = 1.0;
	
	COLOR = text;
}
// =====================================================================
// LABELS

// General notes:
// - `text-halo-rasterizer: fast;` gives a noticeable performance
//    boost to render times and is recommended for *all* halos.

// ---------------------------------------------------------------------
// Languages

// There are 5 language options in the MapBox Streets vector tiles:
// - Local/default: '[name]'
// - English: '[name_en]'
// - French: '[name_fr]'
// - Spanish: '[name_es]'
// - German: '[name_de]'
@name: '[name_en]';  


// ---------------------------------------------------------------------
// Fonts

// All fontsets should have a good fallback that covers as many glyphs
// as possible. 'Arial Unicode MS Regular' and 'Arial Unicode MS Bold' 
//are recommended as final fallbacks if you have them available. 
//They support all the characters used in the MapBox Streets vector tiles.
@fallback: 'Open Sans Regular';
@sans: 'Open Sans Regular', @fallback;
@sans_md: 'Open Sans Semibold', @fallback;
@sans_bd: 'Open Sans Bold', @fallback;
@sans_it: 'Open Sans Italic', @fallback;


// ---------------------------------------------------------------------
// Countries

// The country labels in MapBox Streets vector tiles are placed by hand,
// optimizing the arrangement to fit as many as possible in densely-
// labeled areas.
#place[class='country'][zoom>=1][rank<=2] {
  text-name: @name;
  text-face-name: @sans_bd;
  text-transform: uppercase;
 
  text-wrap-width: 80;
  text-fill: #334;
  text-halo-fill: fadeout(#fff,80%);
  text-halo-radius: 2;
  text-min-distance: 10;
  
  [zoom>=1][rank=1],
  [zoom>=2][rank=2],
  [zoom>=3][rank=3],
  [zoom>=4][rank=4]{
     text-size:11;
  }
  [zoom>=4][rank=1],
  [zoom>=5][rank=2],
  [zoom>=7][rank=3]{
    text-size: 17;
  }
  
  [zoom>=6][rank=4]{
    text-size: 15;
  }
}


// ---------------------------------------------------------------------
// Marine



// ---------------------------------------------------------------------
// Cities, towns, villages, etc

// City labels with dots for low zoom levels.
// The separate attachment keeps the size of the XML down.
#place::citydots[class='city'][zoom>=4][zoom<=7] {
  // explicitly defining all the `ldir` values wer'e going
  // to use shaves a bit off the final project.xml size
  [ldir='N'],[ldir='S'],[ldir='E'],[ldir='W'],
  [ldir='NE'],[ldir='SE'],[ldir='SW'],[ldir='NW'] {
    shield-file: url("shield/dot-small.png");
    shield-unlock-image: true;
    shield-name: @name;
    shield-size: 12;
    [zoom=7] { shield-size: 14; }
    shield-face-name: @sans;
    shield-placement: point;
    shield-fill: #333;
    shield-halo-fill: fadeout(#fff, 50%);
    shield-halo-radius: 1;
    shield-halo-rasterizer: fast;
    [ldir='E'] { shield-text-dx: 5; }
    [ldir='W'] { shield-text-dx: -5; }
    [ldir='N'] { shield-text-dy: -5; }
    [ldir='S'] { shield-text-dy: 5; }
    [ldir='NE'] { shield-text-dx: 4; shield-text-dy: -4; }
    [ldir='SE'] { shield-text-dx: 4; shield-text-dy: 4; }
    [ldir='SW'] { shield-text-dx: -4; shield-text-dy: 4; }
    [ldir='NW'] { shield-text-dx: -4; shield-text-dy: -4; }
  }
}

#place[zoom>=7] {
  text-name: @name;
  text-face-name: @sans;
  text-wrap-width: 120;
  text-wrap-before: true;
  text-fill: #333;
  text-halo-fill: fadeout(#fff, 50%);
  text-halo-radius: 1;
  text-halo-rasterizer: fast;
   text-min-distance: 12;
  [class='city'][zoom>=7][zoom<=15] {
  	text-face-name: @sans_md;
    text-size: 14;
    [zoom>=11] { 
      text-size: 24;
      text-wrap-width: 140;
    }
    // Hide at largest scales:
    [zoom>=16] { text-name: "''"; }
  }
  [class='town'] {
    [zoom>=10] { text-size: 14; }
    [zoom>=15] { text-size: 24; }
    // Hide at largest scales:
    [zoom>=18] { text-name: "''"; }
  }
  [class='village'] {
    [zoom>=10] { text-size: 12; }
    [zoom>=15] { text-size: 22; }
  }
  [class='hamlet'],
  [class='suburb'],
  [class='neighbourhood'] {
    text-fill: #633;
    text-face-name:	@sans_bd;
    text-transform: uppercase;
    text-character-spacing: 0.5;
    [zoom>=12] { text-size: 10; }
    [zoom>=15] { text-size: 14; text-character-spacing: 1; }
  }
}


// ---------------------------------------------------------------------
// Points of interest

#poi[zoom=14][rank<=1],
#poi[zoom=15][rank<=2],
#poi[zoom=16][rank<=3],
#poi[zoom=17][rank<=4][localrank<=2],
#poi[zoom>=18] {
  // Separate icon and label attachments are created to ensure that
  // all icon placement happens first, then labels are placed only
  // if there is still room.
  ::icon[class!=null] {
    // The [maki] field values match a subset of Maki icon names, so we
    // can use that in our url expression.
    // Not all POIs have a Maki icon assigned, so we limit this section
    // to those that do. See also <https://www.mapbox.com/maki/>
    marker-fill:#666;
    marker-file:url('icon/[class]-12.svg');
  }
  ::label {
    text-name: @name;
    text-face-name: @sans_md;
    text-size: 12;
    text-fill: #666;
    text-halo-fill: fadeout(#fff, 50%);
    text-halo-radius: 1;
    text-halo-rasterizer: fast;
    text-wrap-width: 70;
    text-line-spacing:	-1;
    //text-transform: uppercase;
    //text-character-spacing:	0.25;
    // POI labels with an icon need to be offset:
    [class!=null] { text-dy: 8; }
  }
}


// ---------------------------------------------------------------------
// Roads

#transportation_name[ref_length>=1][ref_length<=6]::shield {
  // Motorways with a 'ref' tag that is 1-6 characters long have a
  // [ref] value for shield-style labels.
  // Custom shield png files can be created using make_shields.sh
  // in _src folder
  shield-name: [ref];
  shield-face-name: @sans_bd;
  shield-fill: #765;
  shield-min-distance: 60;
  shield-min-padding: 8;  // prevents clipped shields at tile edges
  shield-size: 9;
  shield-file: url('shield/motorway_sm_[ref_length].png');
  [zoom>=15] {
    shield-size: 11;
    shield-file: url('shield/motorway_lg_[ref_length].png');
  }
}

#transportation_name {
  text-name: @name;
  text-placement: line;  // text follows line path
  text-face-name: @sans;
  text-fill: #765;
  text-halo-fill: fadeout(#fff, 50%);
  text-halo-radius: 1;
  text-halo-rasterizer: fast;
  text-size: 12;
  text-avoid-edges: true;  // prevents clipped labels at tile edges
  [zoom>=15] { text-size: 13; }
}


// ---------------------------------------------------------------------
// Water

#water_name[class='ocean'][zoom>=3]{
    text-name: @name;
    text-face-name: @sans_it;
    text-fill: darken(@water, 15);
    text-wrap-width: 100;
    text-wrap-before: true;
    text-halo-fill: fadeout(#fff, 75%);
    text-wrap-width: 5;
    text-line-spacing: 0.2;
    text-halo-radius: 0.75;
  
   text-size: 18;
  [zoom>=4] {text-size: 22}
  
  [zoom<=13],  // automatic area filtering @ low zooms
  [zoom>=14][area>500000],
  [zoom>=16][area>10000],
  [zoom>=17] {
  
  }  
}

#water_name[class='sea'][zoom>=6]{
    text-name: @name;
    text-face-name: @sans_it;
    text-fill: darken(@water, 15);
    text-wrap-width: 50;
    text-wrap-before: true;
    text-halo-fill: fadeout(#fff, 75%);
    text-wrap-width: 5;
    text-line-spacing: 0.2;
    text-halo-radius: 0.75;
  
   text-size: 18;
  [zoom>=7] {text-size: 22}
  
  [zoom<=13],  // automatic area filtering @ low zooms
  [zoom>=14][area>500000],
  [zoom>=16][area>10000],
  [zoom>=17] {
  
  }  
}


// ---------------------------------------------------------------------
// House numbers

#housenumber[zoom>=17] {
  text-name: [housenumber];
  text-face-name: @sans_it;
  text-fill: #cba;
  text-size: 8;
  [zoom=19] { text-size: 10; }
  [zoom>=20] { text-size: 12; }
}
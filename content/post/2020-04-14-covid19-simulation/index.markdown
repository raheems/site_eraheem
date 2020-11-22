---
title: করোনাভাইরাস ইনফেকশাস ডিজিজ মডেলিং সিমুলেশন
authors: []
date: '2020-04-14'
output: html_document

slug: 'covid19-evaluation-of-non-ppi-intervention-using-simulation'
subtitle: ''
summary: 'কম্পিউটার সিমুলসনের মাধ্যমে বাংলাদেশে করোনাভাইরাসের গতিপ্রকৃতি পর্যবেক্ষণ এবং বিভিন্ন ইন্টেরভেনশনের কার্যকারিতা পরীক্ষণ'
categories: ["COVID19"]
tags: ["COVID19", "বাংলা"]
lastmod: '2020-04-14'
draft: true
featured: yes
diagram: true
image:
  placement: 1
  caption: ""
  focal_point: "Center"
  preview_only: true
projects: ["covid19"]
---

# সিমুলেশন {#simulation}

সিমুলেশনকে আমি যেভাবে সংজ্ঞায়িত করি সেটি হল--

> Observing a real system without really observing it. 

অর্থাৎ সিমুলেশন হল একটি সিস্টেম কী রকম আচরণ করবে তা কম্পিউটারের মাধ্যমে কৃত্রিম পরিবেশ সৃষ্টি করে সেখানে বিভিন্ন প্যারামিটার পরিবর্তন করে পর্যবেক্ষণ করা। 

একটি উদাহরণ দিলে ভাল বোঝা যাবে। 

বাংলাদশে এখন লকডাউন চলছে। অর্থনীতির উপর এর প্রভাব অনেক। তাই অনেকেই বলছেন দীর্ঘ মেয়াদে লকডাউন কোনও সমাধান নয়। কিন্তু লকডাউন যদি উঠিয়ে নেয়া হয় তাহলে এর প্রভাব কী হতে পারে সেটি আমরা বাস্তবে পরীক্ষা করে দেখতে পারবনা। আর সেখানেই কম্পিউটার সিমুলেশন সহায়তা করতে পারে। সিমুলেশনের মাধ্যমে আমরা এই পরীক্ষাটি করতে পারি এবং সেটি সিদ্ধান্ত গ্রহণে সহায়তা করতে পারে।  




# ভূমিকা {#introduction}

লেখা হচ্ছে।



```
## Warning: package 'tibble' was built under R version 3.6.2
```



## কম্পারটমেন্ট

সংক্রামক রোগের মডেলিং এর জন্য কম্পারটমেন্টাল মডেল বহুল ব্যবহৃত। SIR, SEIR, SIS ইত্যাদি মডেলগুলো ইতোপূর্বে সংক্রামক রোগের মডেলিঙে ব্যবহৃত হয়েছে। সেরকম কিন্তু আরেকটু জটিল একটি মডেল নিয়ে আমরা সিমুলেসন করব। 

কম্পারটমেন্ট গুলোর সংক্ষেপে বর্ণনা দেয়া হল। 


| কম্পারটমেন্ট    |           সংজ্ঞা                                                                     |
|-------------|-----------------------------------------------------------------------------------|
| S           | Susceptible বা আক্রান্ত হতে পারে এমন ব্যক্তি                                               |
| E           | এক্সপোসড **এবং** সংক্রামিত, এখনো সিম্পটম প্রকাশ করছেনা কিন্তু সম্ভাব্য সঙ্ক্রামক        |
| I           | আক্রান্ত, সিম্পটমাটিক **এবং** সংক্রামক                                          |
| Q           | সংক্রামক, কিন্তু নিজে থেকেই কয়ারেন্টাইনে                                                |
| H           | হাসপাতালে নেয়া প্রয়োজন (স্বাভাবিক সময়ে ক্যাপাসিটি থাকলে হাসপাতালে নেয়া হত)                 |
| R           | রিকভার করেছে, নতুন করে আক্রান্ত হবে না                                                     |
| F           | কেইস ফ্যাটালিটি (কোভিড ১৯ এ মারা গেছে, অন্য কারণে নয়)                           |

এই মডেল অনুযায়ী একজন ব্যক্তি এক স্টেজ থেকে আরেক স্টেজে কীভাবে যাচ্ছে তা নিচের ডায়াগ্রাম থেকে বোঝা যাবে। 


<!--html_preserve--><div id="htmlwidget-2c2708cc2811291ed56a" style="width:672px;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-2c2708cc2811291ed56a">{"x":{"diagram":"\ndigraph SEIQHRF {\n\n  # a \"graph\" statement\n  graph [overlap = false, fontsize = 10] #, rankdir = LR]\n\n  # several \"node\" statements\n  node [shape = box,\n        fontname = Helvetica]\n  S[label=\"S=আক্রান্ত হতে পারে এমন\"];\n  E[label=\"E=এক্সপোসড এবং সংক্রামিত,\nসিম্পটম দেখাচ্ছে না,\nসম্ভাব্য সংক্রামক\"];\n  I[label=\"I=সংক্রামিত এবং সংক্রামক\"];\n  Q[label=\"Q=(নিজে-)আইসোলেটেড\n(সংক্রামক)\"];\n  H[label=\"H=হাসপাতাল\nনিতে হবে\"];\n  R[label=\"R=রিকভারি/ইমিউন\"];\n  F[label=\"F=কেইস ফেটালিটি\"]\n\n  # several \"edge\" statements\n  S->E[label=\"a\"]\n  I->S[style=\"dashed\", label=\"x\"]\n  E->I[label=\"b\"]\n  E->S[style=\"dashed\", label=\"y\"]\n  I->Q[label=\"c\"]\n  Q->S[style=\"dashed\", label=\"z\"]\n  I->R[label=\"d\"]\n  I->H[label=\"e\"]\n  H->F[label=\"f\"]\n  H->R[label=\"g\"]\n  Q->R[label=\"h\"]\n  Q->H[label=\"i\"]\n}\n","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

## সিমুলেশন প্যরামিটার {#simulation-parameter}
সিমুলেসন ব্যাপারটি নির্ভর করে এর প্যারামিটারগুলো কীভাবে ধরা হচ্ছে। এই পরীক্ষায় যেভাবে আমি প্যরামিটারগুলো ধরেছি তা দেয়া হল। পসিমুলেসনের প্রয়োজনে এগুলো টিউন করা হবে। উদ্দেশ্য হল বাংলাদেশের জন্য প্রযোজ্য মান দিয়ে মডেল শুরু করা। 

<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#mhimirjvkh .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  /* table.margin.left */
  margin-right: auto;
  /* table.margin.right */
  color: #333333;
  font-size: 16px;
  /* table.font.size */
  background-color: #FFFFFF;
  /* table.background.color */
  width: 90%;
  /* table.width */
  border-top-style: solid;
  /* table.border.top.style */
  border-top-width: 2px;
  /* table.border.top.width */
  border-top-color: #A8A8A8;
  /* table.border.top.color */
  border-bottom-style: solid;
  /* table.border.bottom.style */
  border-bottom-width: 2px;
  /* table.border.bottom.width */
  border-bottom-color: #A8A8A8;
  /* table.border.bottom.color */
}

#mhimirjvkh .gt_heading {
  background-color: #FFFFFF;
  /* heading.background.color */
  border-bottom-color: #FFFFFF;
  /* table.background.color */
  border-left-style: hidden;
  /* heading.border.lr.style */
  border-left-width: 1px;
  /* heading.border.lr.width */
  border-left-color: #D3D3D3;
  /* heading.border.lr.color */
  border-right-style: hidden;
  /* heading.border.lr.style */
  border-right-width: 1px;
  /* heading.border.lr.width */
  border-right-color: #D3D3D3;
  /* heading.border.lr.color */
}

#mhimirjvkh .gt_title {
  color: #333333;
  font-size: 125%;
  /* heading.title.font.size */
  font-weight: initial;
  /* heading.title.font.weight */
  padding-top: 4px;
  /* heading.top.padding - not yet used */
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  /* table.background.color */
  border-bottom-width: 0;
}

#mhimirjvkh .gt_subtitle {
  color: #333333;
  font-size: 85%;
  /* heading.subtitle.font.size */
  font-weight: initial;
  /* heading.subtitle.font.weight */
  padding-top: 0;
  padding-bottom: 4px;
  /* heading.bottom.padding - not yet used */
  border-top-color: #FFFFFF;
  /* table.background.color */
  border-top-width: 0;
}

#mhimirjvkh .gt_bottom_border {
  border-bottom-style: solid;
  /* heading.border.bottom.style */
  border-bottom-width: 2px;
  /* heading.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* heading.border.bottom.color */
}

#mhimirjvkh .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  padding-top: 4px;
  padding-bottom: 4px;
}

#mhimirjvkh .gt_col_headings {
  border-top-style: solid;
  /* column_labels.border.top.style */
  border-top-width: 2px;
  /* column_labels.border.top.width */
  border-top-color: #D3D3D3;
  /* column_labels.border.top.color */
  border-bottom-style: solid;
  /* column_labels.border.bottom.style */
  border-bottom-width: 2px;
  /* column_labels.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* column_labels.border.bottom.color */
  border-left-style: none;
  /* column_labels.border.lr.style */
  border-left-width: 1px;
  /* column_labels.border.lr.width */
  border-left-color: #D3D3D3;
  /* column_labels.border.lr.color */
  border-right-style: none;
  /* column_labels.border.lr.style */
  border-right-width: 1px;
  /* column_labels.border.lr.width */
  border-right-color: #D3D3D3;
  /* column_labels.border.lr.color */
}

#mhimirjvkh .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  /* column_labels.background.color */
  font-size: 100%;
  /* column_labels.font.size */
  font-weight: normal;
  /* column_labels.font.weight */
  text-transform: inherit;
  /* column_labels.text_transform */
  vertical-align: middle;
  padding: 5px;
  margin: 10px;
  overflow-x: hidden;
}

#mhimirjvkh .gt_sep_right {
  border-right: 5px solid #FFFFFF;
}

#mhimirjvkh .gt_group_heading {
  padding: 8px;
  /* row_group.padding */
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 100%;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  text-transform: inherit;
  /* row_group.text_transform */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  border-left-style: none;
  /* row_group.border.left.style */
  border-left-width: 1px;
  /* row_group.border.left.width */
  border-left-color: #D3D3D3;
  /* row_group.border.left.color */
  border-right-style: none;
  /* row_group.border.right.style */
  border-right-width: 1px;
  /* row_group.border.right.width */
  border-right-color: #D3D3D3;
  /* row_group.border.right.color */
  vertical-align: middle;
}

#mhimirjvkh .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  /* row_group.background.color */
  font-size: 100%;
  /* row_group.font.size */
  font-weight: initial;
  /* row_group.font.weight */
  border-top-style: solid;
  /* row_group.border.top.style */
  border-top-width: 2px;
  /* row_group.border.top.width */
  border-top-color: #D3D3D3;
  /* row_group.border.top.color */
  border-bottom-style: solid;
  /* row_group.border.bottom.style */
  border-bottom-width: 2px;
  /* row_group.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* row_group.border.bottom.color */
  vertical-align: middle;
}

#mhimirjvkh .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
  /* row.striping.background_color */
}

#mhimirjvkh .gt_from_md > :first-child {
  margin-top: 0;
}

#mhimirjvkh .gt_from_md > :last-child {
  margin-bottom: 0;
}

#mhimirjvkh .gt_row {
  padding-top: 8px;
  /* data_row.padding */
  padding-bottom: 8px;
  /* data_row.padding */
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  /* table_body.hlines.style */
  border-top-width: 1px;
  /* table_body.hlines.width */
  border-top-color: #D3D3D3;
  /* table_body.hlines.color */
  border-left-style: none;
  /* table_body.vlines.style */
  border-left-width: 1px;
  /* table_body.vlines.width */
  border-left-color: #D3D3D3;
  /* table_body.vlines.color */
  border-right-style: none;
  /* table_body.vlines.style */
  border-right-width: 1px;
  /* table_body.vlines.width */
  border-right-color: #D3D3D3;
  /* table_body.vlines.color */
  vertical-align: middle;
  overflow-x: hidden;
}

#mhimirjvkh .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  /* stub.background.color */
  font-weight: initial;
  /* stub.font.weight */
  text-transform: inherit;
  /* stub.text_transform */
  border-right-style: solid;
  /* stub.border.style */
  border-right-width: 2px;
  /* stub.border.width */
  border-right-color: #D3D3D3;
  /* stub.border.color */
  padding-left: 12px;
}

#mhimirjvkh .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* summary_row.background.color */
  text-transform: inherit;
  /* summary_row.text_transform */
  padding-top: 8px;
  /* summary_row.padding */
  padding-bottom: 8px;
  /* summary_row.padding */
  padding-left: 5px;
  padding-right: 5px;
}

#mhimirjvkh .gt_first_summary_row {
  padding-top: 8px;
  /* summary_row.padding */
  padding-bottom: 8px;
  /* summary_row.padding */
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  /* summary_row.border.style */
  border-top-width: 2px;
  /* summary_row.border.width */
  border-top-color: #D3D3D3;
  /* summary_row.border.color */
}

#mhimirjvkh .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  /* grand_summary_row.background.color */
  text-transform: inherit;
  /* grand_summary_row.text_transform */
  padding-top: 8px;
  /* grand_summary_row.padding */
  padding-bottom: 8px;
  /* grand_summary_row.padding */
  padding-left: 5px;
  padding-right: 5px;
}

#mhimirjvkh .gt_first_grand_summary_row {
  padding-top: 8px;
  /* grand_summary_row.padding */
  padding-bottom: 8px;
  /* grand_summary_row.padding */
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  /* grand_summary_row.border.style */
  border-top-width: 6px;
  /* grand_summary_row.border.width */
  border-top-color: #D3D3D3;
  /* grand_summary_row.border.color */
}

#mhimirjvkh .gt_table_body {
  border-top-style: solid;
  /* table_body.border.top.style */
  border-top-width: 2px;
  /* table_body.border.top.width */
  border-top-color: #D3D3D3;
  /* table_body.border.top.color */
  border-bottom-style: solid;
  /* table_body.border.bottom.style */
  border-bottom-width: 2px;
  /* table_body.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* table_body.border.bottom.color */
}

#mhimirjvkh .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  /* footnotes.background.color */
  border-bottom-style: none;
  /* footnotes.border.bottom.style */
  border-bottom-width: 2px;
  /* footnotes.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* footnotes.border.bottom.color */
  border-left-style: none;
  /* footnotes.border.lr.color */
  border-left-width: 2px;
  /* footnotes.border.lr.color */
  border-left-color: #D3D3D3;
  /* footnotes.border.lr.color */
  border-right-style: none;
  /* footnotes.border.lr.color */
  border-right-width: 2px;
  /* footnotes.border.lr.color */
  border-right-color: #D3D3D3;
  /* footnotes.border.lr.color */
}

#mhimirjvkh .gt_footnote {
  margin: 0px;
  font-size: 90%;
  /* footnotes.font.size */
  padding: 4px;
  /* footnotes.padding */
}

#mhimirjvkh .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  /* source_notes.background.color */
  border-bottom-style: none;
  /* source_notes.border.bottom.style */
  border-bottom-width: 2px;
  /* source_notes.border.bottom.width */
  border-bottom-color: #D3D3D3;
  /* source_notes.border.bottom.color */
  border-left-style: none;
  /* source_notes.border.lr.style */
  border-left-width: 2px;
  /* source_notes.border.lr.style */
  border-left-color: #D3D3D3;
  /* source_notes.border.lr.style */
  border-right-style: none;
  /* source_notes.border.lr.style */
  border-right-width: 2px;
  /* source_notes.border.lr.style */
  border-right-color: #D3D3D3;
  /* source_notes.border.lr.style */
}

#mhimirjvkh .gt_sourcenote {
  font-size: 90%;
  /* source_notes.font.size */
  padding: 4px;
  /* source_notes.padding */
}

#mhimirjvkh .gt_left {
  text-align: left;
}

#mhimirjvkh .gt_center {
  text-align: center;
}

#mhimirjvkh .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#mhimirjvkh .gt_font_normal {
  font-weight: normal;
}

#mhimirjvkh .gt_font_bold {
  font-weight: bold;
}

#mhimirjvkh .gt_font_italic {
  font-style: italic;
}

#mhimirjvkh .gt_super {
  font-size: 65%;
}

#mhimirjvkh .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="mhimirjvkh" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">DiagramRef</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Parameter</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Default</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Explanation</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>type</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>SEIQHRF</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>নানা ধরণের মডেল আছে, যেমন SI, SIR, SIS, SEIR, SEIQHR এবং SEIQHRF, এখানে SEIQHRF মডেল নিয়ে সিমুলেসন করা হবে</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>nsteps</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>366</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>সিমুলেসন যত দিনের জন্য করা হচ্ছে। ৩৬৬ মানে এক বছর।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>nsims</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>10</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>গড়ে যতগুলো রিপিটশন করে হবে।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>ncores</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>4</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>সিপিইঊ কোর।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>b</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>prog.rand</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>FALSE</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>যেভাবে <strong>E</strong> কম্পারটমেন্ট থেকে <strong>I</strong> কম্পারটমেন্টে যাবে তার মেথড। TRUE হলে করে দ্বিপদ বিন্যাস থেকে <code>prog.rate</code> অনুযায়ী দৈব চয়ন করে বেছে নেয়া হবে। FALSE হলে Weibull ডিস্ট্রিবিউশন থেকে ডেটা জেনারেট করা হবে যার প্যারামিটার হবে <code>prog.dist.scale</code> এবং <code>prog.dist.shape</code></p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>d,g,h</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>rec.rand</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>FALSE</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>I, Q, H থেকে রিকভারি কম্পারটমেন্টে ট্রাঞ্জিশন মেথড। TRUE হলে দ্বিপদ বিন্যাস থেকে <code>prog.rate</code> অনুযায়ী দৈব চয়ন করে বেছে নেয়া হবে। FALSE হলে Weibull ডিস্ট্রিবিউশন থেকে ডেটা জেনারেট করা হবে যার প্যারামিটার হবে <code>prog.dist.scale</code> এবং <code>prog.dist.shape</code></p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>f</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>fat.rand</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>FALSE</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>H থেকে F কম্পারটমেন্টে ট্রাঞ্জিশনের মেথড। TRUE হলে দ্বিপদ বিন্যাস থেকে <code>fat.rate.base</code> অনুযায়ী দৈব চয়ন করে বেছে নেয়া হবে। FALSE হলে স্যাম্পল ফ্রাকশন নেয়া হবে <code>fat.rate.base</code> অনুযায়ী। কিন্তু, H কম্পারটমেন্টে বর্তমান রোগীর সংখ্যা যদি হাসপাতালের ক্যাপাসিটির (<code>hosp.cap</code>) চেয়ে বেশি হয় তাহলে বেইজ ফেটালিটিকে হাসপাতালের ক্যাপাসিটির ওয়েটেড এভারেজ দিয়ে স্থির করা হবে। ঊপরন্ত আরেকটু বেশি রেট যোগ করা হবে যা <code>fat.rate.overcap</code> দিয়ে নির্দিষ্ট করা।  <code>fat.rate.overcap</code> বেশি করে ধরার মাধ্যমে ক্যাপাসিটি ছাড়িয়ে গেলে স্বাস্থ্য ব্যবস্থার উপর কিরকম প্রভাব পরবে তা সিমুলেট করা যাবে। <code>fat.tcoeff</code> কোফিসিয়েন্ট একজন রোগী H কম্পারটমেন্টে যতদিন আছে তার সাথে মারা যাওয়ার সম্ভাবনার লিনিয়ার সম্পর্ক নির্দেশক। <code>fat.tcoeff</code> আইসিইঊ রোগীদের সারভাইভাল সময়ের ডিস্ট্রিবিউশনেকে ভালভাবে এপ্রক্সিমেট করতে পারে।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>c</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>quar.rand</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>FALSE</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>I থেকে Q কম্পারটমেন্টে ট্রানজিশনের মেথড। TRUE হলে দ্বিপদ বিন্যাস থেকে <code>quar.tate</code> অনুযায়ী দৈব চয়ন করে বেছে নেয়া হবে। FALSE হলে `quar.rate অনুসারে দৈব চয়নের মাধ্যমে আংশিক স্যাম্পল নেয়া হবে।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>e,i</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>hosp.rand</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>FALSE</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>I থেকে H বা Q থেকে H এ স্থানান্তরের মেথড। TRUE হলে দ্বিপদ বিন্যাস থেকে <code>hosp.rate</code> অনুযায়ী দৈব চয়ন করে বেছে নেয়া হবে। FALSE হলে <code>hosp.rate</code> অনুসারে দৈব চয়নের মাধ্যমে আংশিক স্যাম্পল নেয়া হবে।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>e,i</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>disch.rand</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>FALSE</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>হাসপাতালে নেয়ার প্রয়োজন ছিল সেরকম অবস্থা থেকে রিকভারি স্টেজে যাওয়ার মেথড। TRUE হলে দ্বিপদ বিন্যাস থেকে <code>disch.rate</code> অনুযায়ী দৈব চয়ন করে বেছে নেয়া হবে। FALSE হলে <code>disch.rate</code> অনুসারে দৈব চয়নের মাধ্যমে আংশিক স্যাম্পল নেয়া হবে। স্মরণ করা যেতে পারে যে H স্টেজ থেকে বের হওয়ার একমাত্র উপায় হল রিকভারি অথবা মৃত্যু।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>s.num</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>9997</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p><strong>S</strong> কম্পারটমেন্টে মানুষের প্রাথমিক সংখ্যা।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>e.num</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>0</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p><strong>E</strong> কম্পারটমেন্টে মানুষের প্রাথমিক  সংখ্যা।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>i.num</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>3</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p><strong>I</strong> কম্পারটমেন্টে মানুষের প্রাথমিক  সংখ্যা।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>q.num</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>0</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p><strong>Q</strong> কম্পারটমেন্টে মানুষের প্রাথমিক  সংখ্যা।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>h.num</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>0</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p><strong>H</strong> কম্পারটমেন্টে মানুষের প্রাথমিক  সংখ্যা।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>r.num</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>0</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p><strong>R</strong> কম্পারটমেন্টে মানুষের প্রাথমিক  সংখ্যা।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>f.num</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>0</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p><strong>F</strong>কম্পারটমেন্টে মানুষের প্রাথমিক  সংখ্যা।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>x</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>act.rate.i</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>8</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p><strong>I</strong> এবং <strong>S</strong> কম্পারটমেন্টের ব্যক্তির মধ্যে দিনে গড়ে যতবার সংস্পর্শ হবে। প্রতিটি সংস্পর্শ মানেই আক্রান্ত হওয়া নয়। আক্রান্ত হওয়ার সম্ভাবনা <code>inf.prob.i</code> নির্ধারিত হবে। যেমন, সোশাল ডিস্টান্সিং এর এফেক্ট দেখতে চাইলে <code>act.rate.i</code> মান কমিয়ে দিতে হবে।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>x</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>inf.prob.i</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>0.03</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p><strong>I</strong> এবং <strong>S</strong> কম্পারটমেন্টের ব্যক্তির মধ্যে প্রতি সংস্পর্শে রোগ সঙ্ক্রমণের সম্ভাবনা। <code>inf.prob.i</code> কমিয়ে দেয়া অনেকটা হাইজিন চর্চা বাড়ানোর মত।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>y</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>act.rate.e</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>10</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p><strong>E</strong> এবং <strong>S</strong> কম্পারটমেন্টের ব্যক্তির মধ্যে দিনে গড়ে যতবার সংস্পর্শ হবে।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>y</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>inf.prob.e</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>0.02</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p><strong>E</strong> এবং <strong>S</strong> কম্পারটমেন্টের ব্যক্তির মধ্যে প্রতি সংস্পর্শে রোগ সঙ্ক্রমণের সম্ভাবনা। অন্যথায় <code>inf.exp.i</code>.</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>z</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>act.rate.q</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>2</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p><strong>Q</strong> (কয়ারেন্টিন্ড) ব্যক্তির সাথে <strong>S</strong> কম্পারটমেন্টের ব্যক্তির মধ্যে দিনে গড়ে যতবার সংস্পর্শ হবে। অন্যথায় <code>act.rate.i</code>.</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>z</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>inf.prob.q</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>0.02</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p><strong>Q</strong> এবং <strong>S</strong> কম্পারটমেন্টের ব্যক্তির মধ্যে প্রতি সংস্পর্শে রোগ সঙ্ক্রমণের সম্ভাবনা। অন্যথায়<code>inf.exp.i</code>.</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>c</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>quar.rate</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>1/100</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>প্রতদিন গড়ে <strong>I</strong> গ্রুপের আক্রান্ত মানুষেরা যে হারে <strong>Q</strong> কম্পারটমেন্টে নিজে থেকে কোয়ারেন্টিনে যায়। যারা লক্ষণ দেখায়না, অর্থাৎ <strong>E</strong> কম্পারটমেন্টে আছে, তারা আইসলেসনে যায় না কারণ তারা জানেনা যে তারা সঙ্ক্রামক কিনা।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>e,i</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>hosp.rate</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>1/100</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>প্রতিদিন গড়ে লক্ষণ ওয়ালা এবং পজিটিভ ব্যক্তি (<strong>I</strong>) এবং (<strong>Q</strong>) কম্পারটমেন্টের ব্যক্তি এমন অবস্থায় পৌঁছে যে হাসপাতালে নেয়ার প্রয়োজন হয়। অর্থাৎ তারা ক্রিটিকাল অবস্থায় চলে যায়। ডিফল্ট হল 1% প্রতি দিন।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>g</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>disch.rate</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>6/100</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>হাসপাতালের প্রয়োজন হয়েছিল এমনদের মধ্যে দৈনিক গড়ে যতজন রিকভার করে।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>b</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>prog.rate</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>10/100</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p><strong>E</strong> থেকে গড়ে দৈনিক <strong>I</strong> কম্পারটমেন্টে যাওয়ার হার। <code>prog.rand</code> দেখুন।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>b</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>prog.dist.scale</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>5</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>Weibull  ডিস্ট্রিবিউশনের স্কেল প্যরামিটার। <code>prog.rand</code> দেখুন।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>b</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>prog.dist.shape</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>1.5</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>Weibull  ডিস্ট্রিবিউশনের  সেইপ প্যরামিটার। <code>prog.rand</code> দেখুন।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>d</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>rec.rate</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>1/20</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>দৈনিক রিকভারি রেইট অর্থাৎ <strong>I</strong> থেকে <strong>R</strong> এ যাওয়ার রেইট। <code>rec.rand</code> দেখুন।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>d</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>rec.dist.scale</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>35</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>রিকভারির Weibull ডিস্ট্রিবিউশনের স্কেল প্যরামিটার। <code>rec.rand</code> দেখুন।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>d</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>rec.dist.shape</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>1.5</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>রিকভারির Weibull ডিস্ট্রিবিউশনের সেইপ প্যরামিটার। <code>rec.rand</code> দেখুন।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>f</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>fat.rate.base</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>1/50</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>যাদের হাসপাতালের দরকার তাদের বেজলাইন  দৈনিক মরটালিটি রেইট। <code>fat.rand</code> দেখুন</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>f</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>hosp.cap</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>40</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>সিমুলেটেড পপুলেশনের জন্য হাসপাতালের বেডের সংখ্যা। <code>fat.rand</code> দেখুন।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>f</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>fat.rate.overcap</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>2/100</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>দৈনিক মরটালিট রেইট তাদের মধ্যে যাদের হাসপাতালে নেয়ার দরকার ছিল কিন্তু যায়গা না থাকায় দেয়া যায়নি। (<code>hosp.cap</code> এবং <code>fat.rand</code> দ্রষ্টব্য).</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>f</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>fat.tcoeff</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>0.5</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p><strong>H</strong> কম্পারটমেন্টে থাকার দিনের সংখ্যার সাথে মরটালিটি রেইট যতটুকু অরিতিক্ত বাড়বে তার কোফিশিয়েন্ট। <code>fat.rand</code> দেখুন।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>vital</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>TRUE</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>স্বাভাবিক জন্ম এবং মৃত্যু আমলে নেয়া হচ্ছে।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>a.rate</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>(10.5/365)/1000</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>দৈনিক জন্মহার। যারা জন্মাবে তারা সবাই <strong>S</strong> কম্পারটমেন্টে ঢুকবে।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>ds.rate, de.rate, de.rate, dq.rate, dh.rate, dr.rate</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>various rates</p>
</div></td>
      <td class="gt_row gt_left"><div class='gt_from_md'><p>করোনা ব্যতীত অন্য কারণে মৃত্যুর হার।</p>
</div></td>
    </tr>
    <tr>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'></div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>out</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>mean</p>
</div></td>
      <td class="gt_row gt_left gt_striped"><div class='gt_from_md'><p>n সিমুলেশন রান গুলকে যেভাবে সামারাইজ করা হবে। median এবং percentile ও হতে পারে। <code>EpiModel</code> ডকুমেন্টেশন দেখুন।</p>
</div></td>
    </tr>
  </tbody>
  
  
</table></div><!--/html_preserve-->

<!-- ### Time-variant parameters -->

<!-- Several of the simulation parameters can also be varied over time. That is, as well as accepting a single value, they also accept a vector of values with length equal to `nsteps`, the number of days over which the simulation runs. Assuming `nsteps=366`, we can, for example, set `quar.rate = c(rep(1/10,30), rep(1/3, 335))`. That defines a step function in which the transition-to-isolation rate for the **I** compartment is 0.1 for the first 30 days, then steps up to 0.33 thereafter, reflecting, say, a campaign or government edict to self-isolate. Of course, the vector of values can be a smooth function, or can go up then down again, or whatever you wish to model. This is an extremely powerful feature of computational models such as this, and one very hard to incorporate into purely mathematical models. -->

<!-- Most of the parameters for which time-variation is useful support it. If they don't, you will receive an error message (the table above will be updated to include this information later). -->

<!-- ## `simulate()` wrapper function -->



## বেইজলাইন সিমুলেসন


```
## Time to complete: 65.126 sec elapsed
```

ডিস্ট্রিবিউশন দেখে নেই। 



Now get the timing data.



And visualise it.

<img src="/post/2020-04-14-covid19-simulation/index_files/figure-html/unnamed-chunk-8-1.png" width="768" />

<!-- OK, all of those distributions of the time spent in the various states (compartments) look reasonable, with the exception of _Hospital care required duration_. For quite a few individuals, that duration is zero. You could argue that these are day-only admissions, but really, hospital care should be required for at least one day. It's something that can be fixed later, but it makes little difference for now. -->

<!-- Strictly, you should check these duration distributions for every model you run. In practice, I have used them to check the baseline model, and for spot checks on intervention "experiment" models. But if you change the Weibull distribution parameters for the progression and recovery rates, please do check the duration distributions to ensure they are still sensible. -->

## Visualise prevalence 

Prevalence is the number of individuals in each compartment at each point in time (each day). That's the usual way disease models are presented.



```
## Warning: Removed 5 row(s) containing missing values (geom_path).
```

<img src="/post/2020-04-14-covid19-simulation/index_files/figure-html/unnamed-chunk-9-1.png" width="672" />

OK, that looks very reasonable. Note that almost the entire population ends up being infected. However, the **S** and **R** compartments dominate the plot (good, humanity survives!). Let's re-plot leaving out those compartments.


```
## Warning: Removed 4 row(s) containing missing values (geom_path).
```

<img src="/post/2020-04-14-covid19-simulation/index_files/figure-html/unnamed-chunk-10-1.png" width="672" />

What can we see in this plot of our simulation of our hypothetical world of 10,000 people (meaning the results may be indicative of virus behaviour in the real world, but not necessarily the same timings or values)?

* The epidemic is all over in two months.
* We see typical exponential behaviour, although these are prevalence numbers, not incidence (we can extract incidence from our simulation, as we will see later). We expect incidence to rise exponentially, prevalence tends to start with exponential growth then tapers off. That's what we are seeing here, so that's good.
* The prevalence in the **I** and **Q** compartments mirrors but lags behind the **E** compartment, as expected.
* The number requiring hospitalisation seems reasonable.
* The number in the case fatality compartment is monotonically increasing, as expected.

## Checking the basic reproduction number `\(R_{0}\)`

<!-- In the [previous post on simulation](https://timchurches.github.io/blog/posts/2020-03-10-modelling-the-effects-of-public-health-interventions-on-covid-19-transmission-part-1/), we saw how we could check the `\(R_{0}\)` for our simulated outbreak. Let's repeat that for our baseline simulation. Refer to the [previous post](https://timchurches.github.io/blog/posts/2020-03-10-modelling-the-effects-of-public-health-interventions-on-covid-19-transmission-part-1/) for explanation of what's being done here. -->

<img src="/post/2020-04-14-covid19-simulation/index_files/figure-html/unnamed-chunk-11-1.png" width="672" />

<img src="/post/2020-04-14-covid19-simulation/index_files/figure-html/unnamed-chunk-12-1.png" width="672" />

That `\(R_{0}\)` might seem s bit low - values of around 2 or 2.5 were being quoted in January 2020, but remember our value has been calculated using new estimates of the _serial interval_ that are much shorter than previously assumed. We also have some people going into self-isolation even in our baseline model, but at a desultory rate.

# Running an intervention experiment

Now we are in a position to run an experiment, by altering some parameters of our baseline model.

Thus we ramp up the isolation rate (`quar.rate`) from it's low level of 0.033 (as in the baseline simulation), starting at day 15, up to 0.5 at day 30. We'll write a little function to do that.



Let's examine the result. The code used is similar to that used above for the baseline model and won't be shown here.


```
## Warning: Removed 4 row(s) containing missing values (geom_path).
```

<img src="/post/2020-04-14-covid19-simulation/index_files/figure-html/unnamed-chunk-14-1.png" width="672" />

Let's see that with the baseline again for comparison:
 

```
## Warning: Removed 4 row(s) containing missing values (geom_path).
```

<img src="/post/2020-04-14-covid19-simulation/index_files/figure-html/unnamed-chunk-15-1.png" width="672" />

These figures need to be carefully reviwed to set the initial parameters. 


```
## Warning: Removed 2 row(s) containing missing values (geom_path).
```

<img src="/post/2020-04-14-covid19-simulation/index_files/figure-html/unnamed-chunk-16-1.png" width="672" />


<!-- # Running lots of intervention experiments -->

<!-- OK, the _interventionome_ is a large (and scary) space, we need to start taking a more industrial approach to comparing experiments.  -->

<!-- Let's run a whole lot of experiments with various interventions, described  below. -->

<!-- ## Experiment 2 - more hospital beds -->

<!-- Over a four week period, let's ramp up hospital capacity to triple the baseline level, starting at day 15. Hey, China built a 1000+ bed COVID-19 hospital in Wuhan in just 10 days... -->

<!-- ```{r, echo=TRUE, eval=TRUE} -->
<!-- hosp_cap_ramp <- function(t) { -->
<!--   ifelse(t < 15, 40, ifelse(t <= 45, 40 + (t-15)*(120 - 40)/30, 120)) -->
<!-- } -->

<!-- raise_hosp_cap_sim <- simulate(hosp.cap = hosp_cap_ramp(1:366)) -->
<!-- ``` -->

<!-- ## Experiment 3 - more social distancing starting at day 15 -->

<!-- Let's step up social distancing (decrease exposure opportunities), starting at day 15, in everyone except the self-isolated, who are already practising it. But we'll leave the self-isolation rate at the baseline desultory rate. The increase in social distancing will, when full ramped up by day 30, halve the number of exposure events between the infected and the susceptible each day. -->

<!-- ```{r, echo=TRUE, eval=TRUE} -->
<!-- social_distancing_day15_ramp <- function(t) { -->
<!--   ifelse(t < 15, 10, ifelse(t <= 30, 10 - (t-15)*(10 - 5)/15, 5)) -->
<!-- } -->

<!-- t15_social_distancing_sim <- simulate(act.rate.i = social_distancing_day15_ramp(1:366), -->
<!--                                       act.rate.e = social_distancing_day15_ramp(1:366)) -->
<!-- ``` -->

<!-- ## Experiment 4 - more social distancing but starting at day 30 -->

<!-- Let's repeat that, but we'll delay starting the social distancing ramp-up until day 30. -->

<!-- ```{r, echo=TRUE, eval=TRUE} -->
<!-- social_distancing_day30_ramp <- function(t) { -->
<!--   ifelse(t < 30, 10, ifelse(t <= 45, 10 - (t-30)*(10 - 5)/15, 5)) -->
<!-- } -->

<!-- t30_social_distancing_sim <- simulate(act.rate.i = social_distancing_day30_ramp(1:366), -->
<!--                                       act.rate.e = social_distancing_day30_ramp(1:366)) -->
<!-- ``` -->

<!-- ## Experiment 5 - increase both social distancing and increased self-isolation rates starting day 15 -->

<!-- ```{r, echo=TRUE, eval=FALSE} -->
<!-- quar_rate_ramp <- function(t) { -->
<!--   ifelse(t < 15, 0.0333, ifelse(t <= 30, 0.0333 + (t-15)*(0.5 - 0.0333)/15, 0.5)) -->
<!-- } -->

<!-- ramp_quar_rate_sim <- simulate(quar.rate = quar_rate_ramp(1:366))   -->
<!-- ``` -->

<!-- ```{r, echo=TRUE, eval=TRUE} -->
<!-- t15_soc_dist_quar_sim <- simulate(act.rate.i = social_distancing_day15_ramp(1:366), -->
<!--                                   act.rate.e = social_distancing_day15_ramp(1:366), -->
<!--                                   quar.rate = quar_rate_ramp(1:366)) -->
<!-- ``` -->

<!-- ## Comparing experiments -->

<!-- Let's visualise all those experiments in one plot. -->

<!-- ```{r, echo=TRUE, eval=TRUE, fig.height=12, fig.width=6, layout="l-body-outset"} -->
<!-- baseline_sim$df %>% -->
<!--   select(time, s.num, e.num, i.num, q.num,  -->
<!--                      h.num, r.num, f.num) %>% -->
<!--               mutate(experiment = "0. Baseline") %>% -->
<!--   bind_rows(ramp_quar_rate_sim$df %>% -->
<!--               select(time, s.num, e.num, i.num, q.num,  -->
<!--                      h.num, r.num, f.num) %>% -->
<!--               mutate(experiment = "1. incr quar @ t=15")) %>% -->
<!--   bind_rows(raise_hosp_cap_sim$df %>% -->
<!--               select(time, s.num, e.num, i.num, q.num,  -->
<!--                      h.num, r.num, f.num) %>% -->
<!--               mutate(experiment = "2. incr hos cap @ t=15")) %>% -->
<!--   bind_rows(t15_social_distancing_sim$df %>% -->
<!--               select(time, s.num, e.num, i.num, q.num,  -->
<!--                      h.num, r.num, f.num) %>% -->
<!--               mutate(experiment = "3. incr soc dist @ t=15")) %>% -->
<!--   bind_rows(t30_social_distancing_sim$df %>% -->
<!--               select(time, s.num, e.num, i.num, q.num,  -->
<!--                      h.num, r.num, f.num) %>% -->
<!--               mutate(experiment = "4. incr soc dist @ t=30")) %>% -->
<!--   bind_rows(t15_soc_dist_quar_sim$df %>% -->
<!--               select(time, s.num, e.num, i.num, q.num,  -->
<!--                      h.num, r.num, f.num) %>% -->
<!--               mutate(experiment = "5. incr soc dist & quar @ t=15")) %>% -->
<!--   filter(time <= 150) %>% -->
<!--   pivot_longer(-c(time, experiment), -->
<!--                names_to="compartment", -->
<!--                values_to="count") %>% -->
<!--   filter(compartment %in% c("e.num","i.num", -->
<!--                             "q.num","h.num", -->
<!--                             "f.num")) -> plot_df -->

<!-- plot_df %>% -->
<!--   ggplot(aes(x=time, y=count, colour=compartment)) + -->
<!--     geom_line(size=1.5, alpha=0.7) + -->
<!--     facet_grid(experiment ~ .) + -->
<!--     scale_colour_manual(values = compcols, labels=complabels) + -->
<!--     theme_dark() + -->
<!--     labs(title="Baseline vs experiments", -->
<!--          x="Days since beginning of epidemic", -->
<!--          y="Prevalence (persons)") -->
<!-- ``` -->

<!-- Let's see that again showing just the _requiring hospitalisation_ and _case fatality_ prevalence numbers. -->

<!-- ```{r, echo=TRUE, eval=TRUE, fig.height=12, fig.width=6, layout="l-body-outset"} -->
<!-- plot_df %>% -->
<!--   filter(compartment %in% c("h.num", -->
<!--                             "f.num")) %>% -->
<!--   ggplot(aes(x=time, y=count, colour=compartment)) + -->
<!--     geom_line(size=1.5, alpha=0.7) + -->
<!--     facet_grid(experiment ~ .) + -->
<!--     scale_colour_manual(values = compcols, labels=complabels) + -->
<!--     theme_dark() + -->
<!--     labs(title="Baseline vs experiments", -->
<!--          x="Days since beginning of epidemic", -->
<!--          y="Prevalence (persons)") -->
<!-- ``` -->

<!-- I won't laboriously comment on each experiment, but there are a few things worth remarking upon. -->

<!-- Firstly, increasing hospital capacity is probably sensible, but may have little effect on fatalities if the numbers swamp available capacity by an order of magnitude. And increasing hospital capcity is not easy, nor can it be done swiftly, except perhaps in China. -->

<!-- Secondly, rigorous and swift self-isolation in those who are symptomatic is very effective, especially if done early, even in teh presence of infectivity in the asymptomatic infected.  -->

<!-- Thirdly, increasing social distancing also works, but works much better if done early, possibly before there is an obvious need for it based on numbers infected or deaths. Implement early, implement hard! -->

<!-- Fourthly, a combination of prompt self-isolation plus moderate social distancing is also very effective, without necessarily killing the entire economy. This combination warrants further simulations. It is also the combination recommended by the Imperial College London group (see below). -->

<!-- # Conclusions -->

<!-- At this point, it looks like these extensions to `EpiModel` provide a potentially useful tool for exploring the effects of various public health interventions, in a somewhat realistic manner. It is not nearly as sophisticated as the individual contact model used by the WHO Collaborating Centre for Infectious Disease Modelling at Imperial College London (ICL) for their [latest report on the impact of non-pharmaceutical interventions (NPIs) to reduce COVID-19 mortality and healthcare demand](https://www.imperial.ac.uk/mrc-global-infectious-disease-analysis/news--wuhan-coronavirus/). Nevertheless, even the very preliminary insights provided by the experiments above are consistent with those contained in the ICL report.  -->

<!-- The next steps are: a) to move the code used here into a package to make deployment easier; b) implement modelling of infected arrivals, as discussed; c) improve the default parameterisation of the simulation; and d) validate the simulation results against some real-world data. Assistance from the `R` community in any or all of these tasks would be gratefully received. -->

<!-- ```{r, eval=TRUE} -->
<!-- toc() -->
<!-- ``` -->

## ডেটার সূত্র

- 2019 Novel Coronavirus COVID-19 (2019-nCoV) Data Repository by Johns Hopkins CSSE https://github.com/CSSEGISandData/COVID-19

- নিউ ইয়র্ক টাইমস গিটহাব রিপজিটরি https://github.com/nytimes/covid-19-data

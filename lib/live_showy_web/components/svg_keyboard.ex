defmodule LiveShowyWeb.Components.SvgKeyboard do
  use Surface.Component

  @notes 0..127
         |> Enum.chunk_every(12)

  prop octave, :integer, default: 5
  prop notes, :keyword, default: Enum.at(@notes, 5)
  prop class, :css_class

  defp get_note(octave, note) do
    @notes
    |> Enum.at(octave)
    |> Enum.at(note)
  end

  def render(assigns) do
    ~F"""
    <svg
      id="svg-keyboard"
      viewBox="0 0 1400 1000"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;"
      class={"h-full select-none w-full max-h-96", @class}
      phx-hook="HandleSvgKeyboardPresses"
    >
      <g>
        <path
          data-note={get_note(@octave, 0)}
          class="text-white transition fill-current active:text-brand-500"
          label="C"
          d="M200,10c0,-5.519 -4.481,-10 -10,-10l-180,0c-5.519,0 -10,4.481 -10,10l0,980c0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-980Z"
        />
        <path d="M200,10c0,-5.519 -4.481,-10 -10,-10l-180,0c-5.519,0 -10,4.481 -10,10l0,980c0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-980Zm-10,980c-0,0 -180,0 -180,0c5.519,0 0,-5.519 0,0l0,-980c0,-0 180,-0 180,-0c-5.519,-0 0,5.519 0,-0l0,980Z" />
        <path
          data-note={get_note(@octave, 2)}
          class="text-white transition fill-current active:text-brand-500"
          label="D"
          d="M400,10c0,-5.519 -4.481,-10 -10,-10l-180,0c-5.519,0 -10,4.481 -10,10l-0,980c-0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-980Z"
        />
        <path d="M400,10c0,-5.519 -4.481,-10 -10,-10l-180,0c-5.519,0 -10,4.481 -10,10l-0,980c-0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-980Zm-10,980c-0,0 -180,0 -180,0c5.519,0 -0,-5.519 -0,0l-0,-980c0,0 180,0 180,0c-5.519,0 0,5.519 0,-0l0,980Z" />
        <path
          data-note={get_note(@octave, 4)}
          class="text-white transition fill-current active:text-brand-500"
          label="E"
          d="M600,0l-190,0c-5.519,0 -10,4.481 -10,10l0,980c0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-990Z"
        />
        <path d="M600,0l-190,0c-5.519,0 -10,4.481 -10,10l0,980c0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-990Zm-190,10c0,0 180,0 180,0l0,980c-0,0 -180,0 -180,0c5.519,0 0,-5.519 0,0l0,-980Z" />
        <path
          data-note={get_note(@octave, 5)}
          class="text-white transition fill-current active:text-brand-500"
          label="F"
          d="M800,10c0,-5.519 -4.481,-10 -10,-10l-190,0l0,990c0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-980Z"
        />
        <path d="M800,10c0,-5.519 -4.481,-10 -10,-10l-190,0l0,990c0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-980Zm-10,980c-0,0 -180,0 -180,0c5.519,0 0,-5.519 0,0l-0,-980c-0,0 180,0 180,0c-5.519,0 0,5.519 0,-0l0,980Z" />
        <path
          data-note={get_note(@octave, 7)}
          class="text-white transition fill-current active:text-brand-500"
          label="G"
          d="M1000,10c0,-5.519 -4.481,-10 -10,-10l-180,0c-5.519,0 -10,4.481 -10,10l0,980c0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-980Z"
        />
        <path d="M1000,10c0,-5.519 -4.481,-10 -10,-10l-180,0c-5.519,0 -10,4.481 -10,10l0,980c0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-980Zm-10,980c-0,0 -180,0 -180,0c5.519,0 0,-5.519 0,0l0,-980c0,0 180,0 180,0c-5.519,0 0,5.519 0,-0l0,980Z" />
        <path
          data-note={get_note(@octave, 9)}
          class="text-white transition fill-current active:text-brand-500"
          label="A"
          d="M1200,10c0,-5.519 -4.481,-10 -10,-10l-180,0c-5.519,0 -10,4.481 -10,10l0,980c0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-980Z"
        />
        <path d="M1200,10c0,-5.519 -4.481,-10 -10,-10l-180,0c-5.519,0 -10,4.481 -10,10l0,980c0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-980Zm-190,-0c0,0 180,0 180,0c-5.519,0 -0,5.519 -0,0l0,980c-0,0 -180,0 -180,0c5.519,0 0,-5.519 0,0l0,-980Z" />
        <path
          data-note={get_note(@octave, 11)}
          class="text-white transition fill-current active:text-brand-500"
          label="B"
          d="M1400,10c0,-5.519 -4.481,-10 -10,-10l-180,0c-5.519,0 -10,4.481 -10,10l0,980c0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-980Z"
        />
        <path d="M1400,10c0,-5.519 -4.481,-10 -10,-10l-180,0c-5.519,0 -10,4.481 -10,10l0,980c0,5.519 4.481,10 10,10l180,0c5.519,0 10,-4.481 10,-10l0,-980Zm-10,980c-0,0 -180,0 -180,0c5.519,0 0,-5.519 0,0l0,-980c0,0 180,0 180,0c-5.519,0 0,5.519 0,-0l0,980Z" />
        <path
          data-note={get_note(@octave, 1)}
          class="text-black transition fill-current active:text-brand-500"
          label="C♯ D♭"
          d="M250,5c-0,-2.76 -2.24,-5 -5,-5l-90,0c-2.76,0 -5,2.24 -5,5l0,650c0,2.76 2.24,5 5,5l90,-0c2.76,-0 5,-2.24 5,-5l-0,-650Z"
        />
        <path d="M250,5c-0,-2.76 -2.24,-5 -5,-5l-90,0c-2.76,0 -5,2.24 -5,5l0,650c0,2.76 2.24,5 5,5l90,-0c2.76,-0 5,-2.24 5,-5l-0,-650Zm-2,0l-0,650c-0,1.656 -1.344,3 -3,3c-0,-0 -90,-0 -90,-0c-1.656,-0 -3,-1.344 -3,-3l0,-650c0,-1.656 1.344,-3 3,-3l90,0c1.656,0 3,1.344 3,3Z" />
        <path
          data-note={get_note(@octave, 3)}
          class="text-black transition fill-current active:text-brand-500"
          label="D♯ E♭"
          d="M450,5c-0,-2.76 -2.24,-5 -5,-5l-90,0c-2.76,0 -5,2.24 -5,5l0,650c0,2.76 2.24,5 5,5l90,0c2.76,0 5,-2.24 5,-5l-0,-650Z"
        />
        <path d="M450,5c0,-2.76 -2.24,-5 -5,-5l-90,0c-2.76,0 -5,2.24 -5,5l0,650c0,2.76 2.24,5 5,5l90,0c2.76,0 5,-2.24 5,-5l0,-650Zm-2,0l-0,650c-0,1.656 -1.344,3 -3,3c-0,0 -90,0 -90,0c-1.656,0 -3,-1.344 -3,-3l0,-650c0,-1.656 1.344,-3 3,-3l90,0c1.656,0 3,1.344 3,3Z" />
        <path
          data-note={get_note(@octave, 6)}
          class="text-black transition fill-current active:text-brand-500"
          label="F♯ G♭"
          d="M850,5c-0,-2.76 -2.24,-5 -5,-5l-90,0c-2.76,0 -5,2.24 -5,5l0,650c0,2.76 2.24,5 5,5l90,-0c2.76,-0 5,-2.24 5,-5l-0,-650Z"
        />
        <path d="M850,5c-0,-2.76 -2.24,-5 -5,-5l-90,0c-2.76,0 -5,2.24 -5,5l0,650c0,2.76 2.24,5 5,5l90,-0c2.76,-0 5,-2.24 5,-5l-0,-650Zm-2,0l-0,650c-0,1.656 -1.344,3 -3,3c-0,-0 -90,-0 -90,-0c-1.656,-0 -3,-1.344 -3,-3c0,-0 0,-650 0,-650c0,-1.656 1.344,-3 3,-3l90,0c1.656,0 3,1.344 3,3Z" />
        <path
          data-note={get_note(@octave, 8)}
          class="text-black transition fill-current active:text-brand-500"
          label="G♯ A♭"
          d="M1050,5c0,-2.76 -2.24,-5 -5,-5l-90,0c-2.76,0 -5,2.24 -5,5l0,650c0,2.76 2.24,5 5,5l90,0c2.76,0 5,-2.24 5,-5l0,-650Z"
        />
        <path d="M1050,5c0,-2.76 -2.24,-5 -5,-5l-90,0c-2.76,0 -5,2.24 -5,5l0,650c0,2.76 2.24,5 5,5l90,0c2.76,0 5,-2.24 5,-5l0,-650Zm-2,0l0,650c0,1.656 -1.344,3 -3,3c-0,0 -90,0 -90,0c-1.656,0 -3,-1.344 -3,-3c0,-0 0,-650 0,-650c0,-1.656 1.344,-3 3,-3l90,0c1.656,0 3,1.344 3,3Z" />
        <path
          data-note={get_note(@octave, 10)}
          class="text-black transition fill-current active:text-brand-500"
          label="A♯ B♭"
          d="M1250,5c0,-2.76 -2.24,-5 -5,-5l-90,0c-2.76,0 -5,2.24 -5,5l0,650c0,2.76 2.24,5 5,5l90,0c2.76,0 5,-2.24 5,-5l0,-650Z"
        />
        <path d="M1250,5c0,-2.76 -2.24,-5 -5,-5l-90,0c-2.76,0 -5,2.24 -5,5l0,650c0,2.76 2.24,5 5,5l90,0c2.76,0 5,-2.24 5,-5l0,-650Zm-2,0l0,650c0,1.656 -1.344,3 -3,3c-0,0 -90,0 -90,0c-1.656,0 -3,-1.344 -3,-3c0,-0 0,-650 0,-650c0,-1.656 1.344,-3 3,-3l90,0c1.656,0 3,1.344 3,3Z" />
      </g>
    </svg>
    """
  end
end

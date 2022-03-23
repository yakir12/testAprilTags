using VideoIO, AprilTags, GLMakie

detector = AprilTagDetector()
cam = opencamera()

img = read(cam)
frame = Observable(collect(rotr90(img)))
tags = map(detector, frame)
xy = Observable(rand(Point2f, 4))
color = Observable(RGBAf(1,0,0,0))
on(tags) do tags
  if !isempty(tags)
    tag = only(tags)
    xy[] = Point2f.(reverse.(tag.p))
    color[] = RGBAf(1,0,0,0.5)
  else
    color[] = RGBAf(0,0,0,0)
  end
end


fig = Figure()
ax = Axis(fig[1,1], aspect = DataAspect())
image!(ax, frame)
poly!(ax, xy; color)
hidedecorations!(ax)


t = @async while isopen(cam)
  read!(cam, img)
  frame[] = collect(rotr90(img))
  sleep(0.001)
end


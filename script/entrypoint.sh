#!@shell@

ARGS=${@:-none}

cat << EOM
Hello! Here's some information about this image:

{
  built-by:    @system@,
  built-for:   @targetSystem@,
  shell:       @shell@,
  base-image:  @baseImageName@
  args-passed: ${ARGS}
}
EOM

#@ except: LineWidth

version 1.1

task foo {
    meta {
        description: "test task"
        outputs: {
            out: "output file"
        }
    }

    command <<<
        echo "hello" > out
    >>>

    output {
        File out = "out"
    }

    runtime {
        container: "ubuntu@sha256:67541378af7d535606e684a8234d56ca0725b6a4d8b0bbf19cebefed98e06f42"
    }
}

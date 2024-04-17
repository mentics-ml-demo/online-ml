workspace {
    # !identifiers hierarchical

    model {
        user_monitor = Person "Adminstrator"
        user_prediction = Person "User of Predict"

        external_data = SoftwareSystem "External Data" "Source of data coming into the system."

        softwareSystem = SoftwareSystem "Software System" "My software system." {
            ingest = Container "Ingest" {
                monitor = Component "Monitor"
            }
            predict = Container "Predict"
            label = Container "Label"
            train = Container "Train"
            ui = Container "Web UI"

            redpanda = Container "RedPanda" {
                series_raw = Component "Raw Topic"
                series_features = Component "Features Topic"
                series_actual = Component "Actual Topic"
            }
            scylladb = Container "ScyllaDB" {
                prediction = Component "Prediction"
                summary = Component "Reporting Data"
            }

            models = Container "Model Store"

            external_data -> ingest "read websocket stream"
            ingest -> series_raw "write stream raw"
            ingest -> series_features "write stream feature"
            # predict <- redpanda "read stream feature window"
            series_features -> predict "read stream feature window"
            predict -> prediction "write predict"
            # label <- redpanda "read stream raw"
            series_raw -> label "read stream raw"
            label -> series_actual "write stream actual"
            # train <- redpanda "read stream actual" # trigger
            series_actual -> train "read stream actual" # trigger
            # train <- redpanda "read predict"
            redpanda -> train "read predict"
            # train <- models "read model versions"
            models -> train "read model versions"
            train -> models "write updated model versions"
        }

        monitor -> user_monitor "monitors"
        summary ->  "ui"
        ui -> user_prediction "reports"

        # deploymentEnvironment "Production" {
        #     deploymentNode {

        #     }
        # }
    }

    views {
        # systemContext SoftwareSystem "SystemContext" {
        #     include *
        #     autoLayout
        # }

        # styles {
        #     element "Software System" {
        #         background #1168bd
        #         color #ffffff
        #     }
        #     element "Person" {
        #         shape person
        #         background #08427b
        #         color #ffffff
        #     }
        # }
            styles {
                element "Element" {
                background #1168bd
                color #ffffff
                shape RoundedBox
            }

            themes  https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json https://static.structurizr.com/themes/kubernetes-v0.3/theme.json
        }
    }
}
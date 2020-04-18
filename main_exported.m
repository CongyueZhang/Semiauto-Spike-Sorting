classdef main_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        GridLayout              matlab.ui.container.GridLayout
        LeftPanel               matlab.ui.container.Panel
        RunButton               matlab.ui.control.Button
        DataPathEditField       matlab.ui.control.EditField
        ClusternDropDownLabel   matlab.ui.control.Label
        ClusternDropDown        matlab.ui.control.DropDown
        SelectClustersButton    matlab.ui.control.Button
        FunctionDropDownLabel   matlab.ui.control.Label
        FunctionDropDown        matlab.ui.control.DropDown
        RunFunctionButton       matlab.ui.control.Button
        AddClustersButton       matlab.ui.control.Button
        DataPathEditFieldLabel  matlab.ui.control.Label
        RightPanel              matlab.ui.container.Panel
        UIAxes                  matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    methods (Access = public)

        %ÿÿÿÿspikesÿÿÿÿ
        function waveformsPlotting(app,option)
            global data;
            global c;
            global colors;
            global n;
            spikes_length = size(data.waveforms2,2);
            spikes_max = max(data.waveforms2,[],'all');
            spikes_min = min(data.waveforms2,[],'all');
            
            switch option
                case 'Raw Spikes'
                    c = plot(app.UIAxes,data.waveforms2','color','#0072BD');
                    axis(app.UIAxes,[0 spikes_length spikes_min spikes_max]);
                case 'Show n'
                    cla(app.UIAxes);
                    
                    name = split(app.ClusternDropDown.Value,' ');
                    m = str2double(name{2});

                    if isempty(colors)
                        plot(app.UIAxes,data.waveforms2(data.idx == m,:)','color','#0072BD');
                    else
                        plot(app.UIAxes,data.waveforms2(data.idx == m,:)','color',colors(m,:));
                    end
                    axis(app.UIAxes,[0 spikes_length spikes_min spikes_max]);
                case 'Show All Clusters'
                    clf(app.AItxes);
                    m = max(data.idx);
                    colors = distinguishable_colors(n,'w');
                    for i = 1:m
                        hold on;
                        n_index1 = data.idx == i;
                        plot(app.UIAxes,data.waveforms2(n_index1,:)','color',colors(i,:));
                        axis(app.UIAxes,[0 spikes_length spikes_min spikes_max]);
                    end
                case 'View n in data'
                    
                case 'View all in data'
                    
                case 'n''s frequency'
                    
                case 'all''s frequency'
                    
            end

        end

        %{
        %spikesÿÿÿÿÿÿÿÿÿ
        function waveformsPlotting(app)
            global data;
            spikes_length = size(data.waveforms2,2);
            spikes_max = max(data.waveforms2,[],'all');
            spikes_min = min(data.waveforms2,[],'all');            
            for i = 1:spikes_length
                a = unique(data.waveforms2(:,i));
                scatter(app.UIAxes,i*ones(size(a,1),1),a,".",'MarkerEdgeColor','#0072BD');
                hold on;
                axis([0 spikes_length spikes_min spikes_max]);
            end
            
        end
        
        %}
        
        function addClusters(app)
            global n;
            global data;
            global line;
            global c;
            
            m = size(data.waveforms2,1);
            t1 = min(int16(line.Position(:,1)));
            t2 = max(int16(line.Position(:,1)));
            v1 = min(line.Position(:,2))*ones(1,t2-t1+1);
            v2 = max(line.Position(:,2))*ones(1,t2-t1+1);
            for i = 1:m
                if data.idx(i) ~= 0
                    continue;
                end
                
                if sum(data.waveforms2(i,t1:t2) >= v1 & data.waveforms2(i,t1:t2) <= v2) >= 1
                    %try
                        delete(c(i));
                        data.idx(i) = n;
                    %catch
                    %end
                end
            end

                delete(line);

        end
        
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.ClusternDropDown.Items = {};
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {465, 465};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {247, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end

        % Callback function: DataPathEditField, RunButton
        function RunButtonPushed(app, event)
            addpath('E:\ÿÿÿÿ\data processing\project\matlab');
            addpath('E:\ÿÿÿÿ\data processing\project\matlab\MyFunctions');
            addpath('E:\ÿÿÿÿ\data processing\project\matlab\MyFunctions\plotting');
            global data;
            global n;
            n = 0;
            
            if isempty(app.DataPathEditField.Value)
                fig = app.UIFigure;
                message = sprintf('path not found');
                uialert(fig,message,'Warning',...
                'Icon','warning');
            else
            
                d = uiprogressdlg(app.UIFigure,'Title','Preprocessing . . .',...
                'Indeterminate','on');
                
                data = data_processing(app.DataPathEditField.Value);
                waveformsPlotting(app,'Raw Spikes');
            end
            
            close(d);
        end

        % Button pushed function: SelectClustersButton
        function SelectClustersButtonPushed(app, event)
            global line;
            line = drawline(app.UIAxes,'Color','r');
        end

        % Button pushed function: AddClustersButton
        function AddClustersButtonPushed(app, event)
            global n;
            n = n+1;
            addClusters(app);
            app.ClusternDropDown.Items{end+1} = ['Cluster ' int2str(n)];
        end

        % Button pushed function: RunFunctionButton
        function RunFunctionButtonPushed(app, event)
            switch app.FunctionDropDown.Value
                case 'Show n'
                    waveformsPlotting(app,"Show n");
                case 'Show All Clusters'
                    waveformsPlotting(app,"Show All Clusters")
                case 'View n in data'
                    
                case 'View all in data'
                    
                case 'n''s frequency'
                    
                case 'all''s frequency'
            end           
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 971 465];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {247, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;
            app.LeftPanel.Scrollable = 'on';

            % Create RunButton
            app.RunButton = uibutton(app.LeftPanel, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.Position = [74 363 100 22];
            app.RunButton.Text = 'Run';

            % Create DataPathEditField
            app.DataPathEditField = uieditfield(app.LeftPanel, 'text');
            app.DataPathEditField.ValueChangedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.DataPathEditField.Position = [95 401 120 22];

            % Create ClusternDropDownLabel
            app.ClusternDropDownLabel = uilabel(app.LeftPanel);
            app.ClusternDropDownLabel.HorizontalAlignment = 'right';
            app.ClusternDropDownLabel.Position = [40 255 54 22];
            app.ClusternDropDownLabel.Text = 'Cluster n';

            % Create ClusternDropDown
            app.ClusternDropDown = uidropdown(app.LeftPanel);
            app.ClusternDropDown.Items = {};
            app.ClusternDropDown.Position = [109 255 100 22];
            app.ClusternDropDown.Value = {};

            % Create SelectClustersButton
            app.SelectClustersButton = uibutton(app.LeftPanel, 'push');
            app.SelectClustersButton.ButtonPushedFcn = createCallbackFcn(app, @SelectClustersButtonPushed, true);
            app.SelectClustersButton.Position = [24 305 96 22];
            app.SelectClustersButton.Text = 'Select Clusters';

            % Create FunctionDropDownLabel
            app.FunctionDropDownLabel = uilabel(app.LeftPanel);
            app.FunctionDropDownLabel.HorizontalAlignment = 'right';
            app.FunctionDropDownLabel.Position = [40 221 52 22];
            app.FunctionDropDownLabel.Text = 'Function';

            % Create FunctionDropDown
            app.FunctionDropDown = uidropdown(app.LeftPanel);
            app.FunctionDropDown.Items = {'Show n', 'Show All Clusters', 'View n in data', 'View all in data', 'n''s frequency', 'all''s frequency'};
            app.FunctionDropDown.Position = [107 221 102 22];
            app.FunctionDropDown.Value = 'Show n';

            % Create RunFunctionButton
            app.RunFunctionButton = uibutton(app.LeftPanel, 'push');
            app.RunFunctionButton.ButtonPushedFcn = createCallbackFcn(app, @RunFunctionButtonPushed, true);
            app.RunFunctionButton.Position = [74 182 100 22];
            app.RunFunctionButton.Text = 'Run Function';

            % Create AddClustersButton
            app.AddClustersButton = uibutton(app.LeftPanel, 'push');
            app.AddClustersButton.ButtonPushedFcn = createCallbackFcn(app, @AddClustersButtonPushed, true);
            app.AddClustersButton.Position = [135 305 100 22];
            app.AddClustersButton.Text = 'Add Clusters';

            % Create DataPathEditFieldLabel
            app.DataPathEditFieldLabel = uilabel(app.LeftPanel);
            app.DataPathEditFieldLabel.HorizontalAlignment = 'right';
            app.DataPathEditFieldLabel.Position = [28 401 59 22];
            app.DataPathEditFieldLabel.Text = 'Data Path';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, 'ÿÿÿÿ')
            xlabel(app.UIAxes, 'Time(ms)')
            ylabel(app.UIAxes, 'Voltage(mV)')
            app.UIAxes.NextPlot = 'add';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.TitleFontWeight = 'bold';
            app.UIAxes.Position = [6 6 712 439];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = main_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
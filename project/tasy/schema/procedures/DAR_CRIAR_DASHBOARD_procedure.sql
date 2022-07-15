-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dar_criar_dashboard ( nr_sequencia_p dar_dashboard.nr_sequencia%type, ds_dashboard_p dar_dashboard.ds_dashboard%type, nr_seq_dimensao_p dar_dashboard.nr_seq_dimensao%type, nr_seq_quantitativo_p dar_dashboard.nr_seq_quantitativo%type, nr_seq_app_p dar_dashboard.nr_seq_app%type, ie_operacao_p dar_dashboard.ie_operacao%type, ie_tipo_grafico_p dar_dashboard.ie_tipo_grafico%type, ds_texto_imagem_p dar_dashboard.ds_texto_imagem%type, nr_seq_dashboard_p INOUT dar_dashboard.nr_sequencia%type ) AS $body$
DECLARE


   nr_sequencia_w               dar_dashboard.nr_sequencia%type;


BEGIN
   --
   nr_sequencia_w := nr_sequencia_p;
   -- se for novo registro
   if (coalesce(nr_sequencia_p, 0) = 0) then
      -- insert record
      insert into dar_dashboard(
        nr_sequencia,        -- 1
        ds_dashboard,        -- 2
        nr_seq_dimensao,     -- 3
        nr_seq_quantitativo, -- 4
        ie_operacao,         -- 5
        dt_atualizacao,      -- 6
        nm_usuario,          -- 7
        dt_atualizacao_nrec, -- 8
        nm_usuario_nrec,     -- 9
          nr_seq_app,          -- 10
          ie_tipo_grafico,     -- 11
          nr_seq_order,        -- 12
        ds_texto_imagem      -- 13
      )
      values (
        nextval('dar_app_seq'),             -- 1
        ds_dashboard_p,                  -- 2
        nr_seq_dimensao_p,               -- 3
        nr_seq_quantitativo_p,           -- 4
        ie_operacao_p,                   -- 5
          clock_timestamp(),                         -- 6
        wheb_usuario_pck.get_nm_usuario, -- 7
        clock_timestamp(),                         -- 8
        wheb_usuario_pck.get_nm_usuario, -- 9
          nr_seq_app_p,                    -- 10
          ie_tipo_grafico_p,               -- 11
          nextval('dar_app_seq'),             -- 12
        ds_texto_imagem_p                -- 13
      )

      returning nr_sequencia INTO nr_sequencia_w;

   else
      -- Update record
      update dar_dashboard
         set ds_dashboard        = ds_dashboard_p,
             nr_seq_dimensao      = nr_seq_dimensao_p,
             nr_seq_quantitativo = nr_seq_quantitativo_p,
             ie_operacao          = ie_operacao_p,
                ie_tipo_grafico     = ie_tipo_grafico_p,
             ds_texto_imagem     = ds_texto_imagem_p
       where nr_sequencia = nr_sequencia_w;
   end if;
   --
   commit;

   -- Return nr_sequencia para criar a primeira tab
   nr_seq_dashboard_p := nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dar_criar_dashboard ( nr_sequencia_p dar_dashboard.nr_sequencia%type, ds_dashboard_p dar_dashboard.ds_dashboard%type, nr_seq_dimensao_p dar_dashboard.nr_seq_dimensao%type, nr_seq_quantitativo_p dar_dashboard.nr_seq_quantitativo%type, nr_seq_app_p dar_dashboard.nr_seq_app%type, ie_operacao_p dar_dashboard.ie_operacao%type, ie_tipo_grafico_p dar_dashboard.ie_tipo_grafico%type, ds_texto_imagem_p dar_dashboard.ds_texto_imagem%type, nr_seq_dashboard_p INOUT dar_dashboard.nr_sequencia%type ) FROM PUBLIC;


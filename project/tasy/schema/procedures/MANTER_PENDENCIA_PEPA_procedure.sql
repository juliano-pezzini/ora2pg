-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE manter_pendencia_pepa ( nr_seq_atend_cons_pepa_p ATEND_CONSULTA_PEPA.NR_SEQUENCIA%type, ie_tipo_item_p text, nr_seq_item_prontuario_p PRONTUARIO_ITEM.NR_SEQUENCIA%type, nr_seq_template_p EHR_TEMPLATE.NR_SEQUENCIA%type, nm_tabela_p text, ds_sequencia_reg_p text, ie_reg_pendente_p text, nr_seq_dbpanel_p OBJETO_SCHEMATIC.NR_SEQUENCIA%type, nr_seq_grupo_escalas_p PERFIL_ESCALA_INDICE.NR_SEQUENCIA%type, nm_usuario_p text) AS $body$
DECLARE

			
nr_sequencia_w PEPA_ITEM_PENDENTE.NR_SEQUENCIA%type;
nr_seq_grupo_tab_w objeto_schematic.nr_sequencia%type;
nr_seq_tab_selecionada_w objeto_schematic.nr_sequencia%type;


BEGIN
	select max(nr_sequencia)
	into STRICT nr_sequencia_w
	from PEPA_ITEM_PENDENTE
	where nr_seq_atend_cons_pepa = nr_seq_atend_cons_pepa_p
	and ie_tipo_item = ie_tipo_item_p
	and ((ie_tipo_item_p = 'TEMPLATE'
	and nr_seq_template = nr_seq_template_p)
	or (nm_tabela = nm_tabela_p
	and ds_sequencia_reg = ds_sequencia_reg_p));

	if (ie_reg_pendente_p = 'S') then
		if (coalesce(nr_sequencia_w::text, '') = '') then

      if (nr_seq_dbpanel_p IS NOT NULL AND nr_seq_dbpanel_p::text <> '') then
        SELECT * FROM obter_metadata_selecao_pepa(nr_seq_dbpanel_p, nr_seq_grupo_tab_w, nr_seq_tab_selecionada_w) INTO STRICT nr_seq_grupo_tab_w, nr_seq_tab_selecionada_w;
      end if;
			insert into PEPA_ITEM_PENDENTE(	
				nr_sequencia,
				nr_seq_atend_cons_pepa,
				ie_tipo_item,
				nr_seq_item_prontuario,
				nm_tabela,
				ds_sequencia_reg,
				nr_seq_template,
        nr_seq_dbpanel,
        nr_seq_tab_selecionada,
        nr_seq_grupo_tab,
        nr_seq_grupo_escalas,
				nm_usuario,
				dt_atualizacao,
				ds_call_stack)
			values (	nextval('pepa_item_pendente_seq'),
				nr_seq_atend_cons_pepa_p,
				substr(ie_tipo_item_p, 0, 20),
				nr_seq_item_prontuario_p,
				substr(nm_tabela_p, 0, 50),
				substr(ds_sequencia_reg_p, 0, 150),
				nr_seq_template_p,
        nr_seq_dbpanel_p,
        nr_seq_tab_selecionada_w,
        nr_seq_grupo_tab_w,
        nr_seq_grupo_escalas_p,
				substr(nm_usuario_p, 0, 15),
				clock_timestamp(),
				substr(dbms_utility.format_call_stack,1,2000));
			commit;
		end if;
	elsif (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		delete from PEPA_ITEM_PENDENTE where nr_sequencia = nr_sequencia_w;
		commit;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE manter_pendencia_pepa ( nr_seq_atend_cons_pepa_p ATEND_CONSULTA_PEPA.NR_SEQUENCIA%type, ie_tipo_item_p text, nr_seq_item_prontuario_p PRONTUARIO_ITEM.NR_SEQUENCIA%type, nr_seq_template_p EHR_TEMPLATE.NR_SEQUENCIA%type, nm_tabela_p text, ds_sequencia_reg_p text, ie_reg_pendente_p text, nr_seq_dbpanel_p OBJETO_SCHEMATIC.NR_SEQUENCIA%type, nr_seq_grupo_escalas_p PERFIL_ESCALA_INDICE.NR_SEQUENCIA%type, nm_usuario_p text) FROM PUBLIC;


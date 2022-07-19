-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_mat_guia_web ( nr_seq_guia_p bigint, nr_seq_material_p bigint, qt_solicitado_p bigint, nm_usuario_p text, ie_tipo_anexo_p text, vl_material_p bigint, nr_seq_guia_mat_p INOUT bigint) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Inserir materiais na guia
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/nr_seq_guia_mat_w		pls_guia_plano_mat.nr_sequencia%type;


BEGIN

if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then

	select  nextval('pls_guia_plano_mat_seq')
	into STRICT	nr_seq_guia_mat_w
	;

	insert into pls_guia_plano_mat(
			nr_sequencia, dt_atualizacao, nm_usuario,
			nr_seq_guia, nr_seq_material,ie_status,
			qt_solicitada, dt_atualizacao_nrec, nm_usuario_nrec,
			ie_origem_inclusao, ie_tipo_anexo, vl_material)
		values (nr_seq_guia_mat_w,clock_timestamp(), nm_usuario_p,
			nr_seq_guia_p, nr_seq_material_p, 'U',
			qt_solicitado_p, clock_timestamp(), nm_usuario_p,
			'P', ie_tipo_anexo_p, vl_material_p);

	if (coalesce(vl_material_p::text, '') = '') then
		CALL pls_atualiza_valor_mat_aut(nr_seq_guia_mat_w, 'A', nm_usuario_p);
	end if;
end if;

nr_seq_guia_mat_p := nr_seq_guia_mat_w;

commit;

end 	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_mat_guia_web ( nr_seq_guia_p bigint, nr_seq_material_p bigint, qt_solicitado_p bigint, nm_usuario_p text, ie_tipo_anexo_p text, vl_material_p bigint, nr_seq_guia_mat_p INOUT bigint) FROM PUBLIC;


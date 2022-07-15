-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_versao_plano ( nm_medico_p text, cd_pessoa_fisica_p text, dt_emissao_p timestamp, nr_seq_versao_p INOUT bigint, qt_peso_p bigint, qt_altura_p bigint, qt_creatinina_p bigint, ie_gravida_p text, ie_amamentacao_p text, ds_alergias_p text, ds_outras_condicoes_p text, xml_version_p text ) AS $body$
DECLARE


	ds_versao_w		varchar(10);
	nr_seq_versao_w   		bigint;


BEGIN

	select coalesce(max((ds_versao)::numeric ), 0) + 1 into STRICT ds_versao_w from plano_versao where cd_pessoa_fisica = cd_pessoa_fisica_p;

  	insert into plano_versao( nr_sequencia,
                	nm_usuario,
                	nm_medico,
                	dt_atualizacao,
                	ds_versao,
                	dt_emissao,
		cd_pessoa_fisica,
		dt_liberacao,
		ie_importado,
		qt_peso,
		qt_altura,
		qt_creatinina,
		ie_gravida,
		ie_amamentacao,
		ds_alergias,
		ds_outras_condicoes,
		ds_versao_xml)
  	values ( nextval('plano_versao_seq'),
                	obter_usuario_ativo(),
                	nm_medico_p,
                	dt_emissao_p,
                	ds_versao_w,
                	dt_emissao_p,
		cd_pessoa_fisica_p,
		clock_timestamp(),
		'S',
		qt_peso_p,
		qt_altura_p,
		qt_creatinina_p,
		ie_gravida_p,
		ie_amamentacao_p,
		ds_alergias_p,
		ds_outras_condicoes_p,
		xml_version_p);

  	commit;

  	select max(nr_sequencia) into STRICT nr_seq_versao_w from plano_versao;

  	nr_seq_versao_p := nr_seq_versao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_versao_plano ( nm_medico_p text, cd_pessoa_fisica_p text, dt_emissao_p timestamp, nr_seq_versao_p INOUT bigint, qt_peso_p bigint, qt_altura_p bigint, qt_creatinina_p bigint, ie_gravida_p text, ie_amamentacao_p text, ds_alergias_p text, ds_outras_condicoes_p text, xml_version_p text ) FROM PUBLIC;


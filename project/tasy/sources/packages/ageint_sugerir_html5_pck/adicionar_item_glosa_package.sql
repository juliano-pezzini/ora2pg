-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ageint_sugerir_html5_pck.adicionar_item_glosa (nr_seq_ageint_item_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_regra_p INOUT bigint, ie_glosa_p INOUT text) AS $body$
DECLARE

    cd_convenio_w 			integer;
	cd_categoria_w			varchar(10);
	cd_plano_w				varchar(10);
	cd_pessoa_fisica_w 		varchar(10);
	ie_tipo_atendimento_w	smallint;
	nr_seq_cobetura_w		bigint;
	ie_glosa_w		varchar(1);
	ie_regra_w		integer;
	nr_seq_regra_w	bigint;

	
BEGIN

		select 	max(a.cd_convenio),
				max(a.cd_categoria),
				max(a.cd_plano),
				max(a.cd_pessoa_fisica),
				max(a.nr_seq_cobertura),
				max(a.ie_tipo_atendimento)
		into STRICT 	cd_convenio_w,
				cd_categoria_w,
				cd_plano_w,
				cd_pessoa_fisica_w,
				nr_seq_cobetura_w,
				ie_tipo_atendimento_w
		from	agenda_integrada a,
				agenda_integrada_item b
		where 	b.nr_sequencia = nr_seq_ageint_item_p
		and 	a.nr_sequencia = b.nr_seq_agenda_int;

		select 	coalesce(max(a.cd_convenio), cd_convenio_w),
				coalesce(max(a.cd_categoria), cd_categoria_w),
				coalesce(max(a.cd_plano), cd_plano_w)
		into STRICT 	cd_convenio_w,
				cd_categoria_w,
				cd_plano_w
		from	agenda_integrada_conv_item a,
				agenda_integrada_item b
		where 	b.nr_sequencia = nr_seq_ageint_item_p
		and     a.nr_seq_agenda_item = 	b.nr_sequencia;


		if (nr_seq_ageint_item_p IS NOT NULL AND nr_seq_ageint_item_p::text <> '' AND cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
			Verificar_Glosa_Item(
				nr_seq_ageint_item_p,
				cd_convenio_w,
				cd_categoria_w,
				cd_estabelecimento_p,
				cd_plano_w,
				nm_usuario_p,
				cd_pessoa_fisica_w,
				ie_tipo_atendimento_w,
				nr_seq_cobetura_w,
				ie_regra_w,
				ie_glosa_w,
				nr_seq_regra_w);

			ie_regra_p := ie_regra_w;
			ie_glosa_p := ie_glosa_w;
		end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_sugerir_html5_pck.adicionar_item_glosa (nr_seq_ageint_item_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_regra_p INOUT bigint, ie_glosa_p INOUT text) FROM PUBLIC;
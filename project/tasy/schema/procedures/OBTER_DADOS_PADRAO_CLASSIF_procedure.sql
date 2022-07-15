-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_padrao_classif (ie_classif_agenda_p text, cd_estabelecimento_p bigint, nm_usuario_p text, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, cd_plano_p INOUT text) AS $body$
DECLARE


nr_seq_regra_w	bigint;
cd_convenio_w	integer;
cd_categoria_w	varchar(10);
cd_plano_w	varchar(10);


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_regra_w
from	regra_classif_info_padrao
where	ie_classif_agenda = ie_classif_agenda_p;

if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
	select	max(cd_convenio),
		max(cd_categoria),
		max(cd_plano)
	into STRICT	cd_convenio_w,
		cd_categoria_w,
		cd_plano_w
	from	regra_classif_info_padrao
	where	nr_sequencia = nr_seq_regra_w;

	cd_convenio_p	:= cd_convenio_w;
	cd_categoria_p	:= cd_categoria_w;
	cd_plano_p	:= cd_plano_w;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_padrao_classif (ie_classif_agenda_p text, cd_estabelecimento_p bigint, nm_usuario_p text, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, cd_plano_p INOUT text) FROM PUBLIC;


-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_equip_hosp ( nr_seq_equip_man_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
cd_estabelecimento_w	smallint;
ds_equipamento_w	varchar(80);
cd_imobilizado_w	varchar(20);
cd_imobilizado_ext_w	varchar(20);


BEGIN

select	coalesce(max(cd_equipamento),0)+1
into STRICT	nr_sequencia_w
from	equipamento;

select	cd_estab_contabil,
	ds_equipamento,
	cd_imobilizado,
	cd_imobilizado_ext
into STRICT	cd_estabelecimento_w,
	ds_equipamento_w,
	cd_imobilizado_w,
	cd_imobilizado_ext_w
from	man_equipamento
where	nr_sequencia = nr_seq_equip_man_p;

insert	into equipamento(
	cd_equipamento,
	cd_estabelecimento,
	ds_equipamento,
	ds_equip_curto,
	dt_atualizacao,
	ie_situacao,
	ie_video,
	ie_locacao,
	ie_terceiro,
	ie_exibe_agendamento,
	ie_agenda_integrada,
	ie_exige_topografia,
	nr_seq_equipamento_man,
	nm_usuario,
	qt_equipamento,
	cd_imobilizado,
	cd_imobilizado_ext)
values (	nr_sequencia_w,
	cd_estabelecimento_w,
	ds_equipamento_w,
	ds_equipamento_w,
	clock_timestamp(),
	'I',
	'N',
	'N',
	'N',
	'S',
	'N',
	'N',
	nr_seq_equip_man_p,
	nm_usuario_p,
	1,
	cd_imobilizado_w,
	cd_imobilizado_ext_w);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_equip_hosp ( nr_seq_equip_man_p bigint, nm_usuario_p text) FROM PUBLIC;

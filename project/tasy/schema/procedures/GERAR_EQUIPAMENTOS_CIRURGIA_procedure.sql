-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_equipamentos_cirurgia (cd_equipamento_p bigint, nr_cirurgia_p bigint, cd_profissional_p text, nm_usuario_p text, nr_sequencia_p INOUT bigint, nr_seq_pepo_p bigint, nr_seq_topografia_p bigint, ie_lado_p text default null, dt_inicio_p timestamp DEFAULT NULL, dt_fim_p timestamp DEFAULT NULL, ie_tecnica_aplicacao_p text default null, ie_eletrodo_neutro_p text default null, cd_resp_eletrodo_neutro_p text default null, ie_tipo_energia_p text default null) AS $body$
DECLARE


nr_sequencia_w		bigint;
ie_inicio_equip_w	varchar(1);
					

BEGIN

ie_inicio_equip_w := obter_param_usuario(872, 363, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_inicio_equip_w);

select	nextval('equipamento_cirurgia_seq')
into STRICT	nr_sequencia_w
;

nr_sequencia_p	:= nr_sequencia_w;

insert into equipamento_cirurgia(
       	nr_sequencia,
	nr_cirurgia,
	cd_equipamento,
	qt_equipamento,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_profissional,
	nr_seq_pepo,
	nr_seq_topografia,
	ie_lado,
	dt_inicio,
	dt_fim,
	ie_tecnica_aplicacao,
	ie_eletrodo_neutro,
	cd_resp_eletrodo_neutro,
	ie_situacao,
    ie_tipo_energia)
values (
	nr_sequencia_w,
	nr_cirurgia_p,
	cd_equipamento_p,
	1,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_profissional_p,
	nr_seq_pepo_p,
	nr_seq_topografia_p,
	ie_lado_p,
	CASE WHEN ie_inicio_equip_w='S' THEN clock_timestamp()  ELSE dt_inicio_p END ,
	dt_fim_p,
	ie_tecnica_aplicacao_p,
	ie_eletrodo_neutro_p,
	cd_resp_eletrodo_neutro_p,
	'A',
    ie_tipo_energia_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_equipamentos_cirurgia (cd_equipamento_p bigint, nr_cirurgia_p bigint, cd_profissional_p text, nm_usuario_p text, nr_sequencia_p INOUT bigint, nr_seq_pepo_p bigint, nr_seq_topografia_p bigint, ie_lado_p text default null, dt_inicio_p timestamp DEFAULT NULL, dt_fim_p timestamp DEFAULT NULL, ie_tecnica_aplicacao_p text default null, ie_eletrodo_neutro_p text default null, cd_resp_eletrodo_neutro_p text default null, ie_tipo_energia_p text default null) FROM PUBLIC;


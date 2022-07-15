-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_gerar_item_cont_expurgo ( nr_seq_item_p bigint, nr_seq_ciclo_p bigint, nr_seq_lote_p bigint, nr_expurgo_retirada_p bigint, nr_expurgo_receb_p bigint, cd_setor_atendimento_p bigint, nm_usuario_barras_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_ciclo_w		bigint;
nr_seq_lote_w		bigint;
nr_seq_embalagem_w	bigint;
qt_ponto_w		double precision;
nr_sequencia_w		bigint;
cd_pessoa_resp_w	varchar(10);
ie_gera_nr_controle_w     varchar(1);
ie_util_adm_lote_w          varchar(1);
nr_seq_controle_w   cm_conjunto_cont.nr_seq_controle%type;


BEGIN

nr_seq_ciclo_w := coalesce(nr_seq_ciclo_p,0);
nr_seq_lote_w := coalesce(nr_seq_lote_p,0);
cd_pessoa_resp_w := obter_pf_usuario(nm_usuario_barras_p,'C');

select	nr_seq_embalagem,
		coalesce(qt_ponto, 0)
into STRICT	nr_seq_embalagem_w,
		qt_ponto_w
from	cm_item
where	nr_sequencia = nr_seq_item_p;

select	nextval('cm_conjunto_cont_seq')
into STRICT	nr_sequencia_w
;

ie_gera_nr_controle_w := obter_param_usuario(406, 2, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_gera_nr_controle_w);
ie_util_adm_lote_w := obter_param_usuario(406, 3, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_util_adm_lote_w);

if (ie_gera_nr_controle_w = 'S' and ie_util_adm_lote_w = 'N') then
    select coalesce(max(nr_seq_controle),0) + 1 qt_max
    into STRICT nr_seq_controle_w
    from cm_conjunto_cont;
end if;

insert into cm_conjunto_cont(
	nr_sequencia,
	nr_seq_item,
	cd_estabelecimento,
	dt_atualizacao,
	nm_usuario,
	ie_status_conjunto,
	dt_origem,
	nm_usuario_origem,
	nr_seq_embalagem,
	dt_receb_ester,
	nm_usuario_ester,
	nr_seq_ciclo,
	vl_esterilizacao,
	qt_ponto,
	cd_setor_atendimento,
	nr_seq_lote,
	ie_situacao,
	cd_pessoa_resp,
	nr_seq_controle)
values (nr_sequencia_w,
	nr_seq_item_p,
	cd_estabelecimento_p,
	clock_timestamp(),
	nm_usuario_barras_p,
	2,
	clock_timestamp(),
	nm_usuario_barras_p,
	nr_seq_embalagem_w,
	clock_timestamp(),
	nm_usuario_barras_p,
	CASE WHEN nr_seq_ciclo_w=0 THEN null  ELSE nr_seq_ciclo_w END ,
	0,
	qt_ponto_w,
	cd_setor_atendimento_p,
	CASE WHEN nr_seq_lote_w=0 THEN null  ELSE nr_seq_lote_w END ,
	'A',
	cd_pessoa_resp_w,
	nr_seq_controle_w);

if (nr_expurgo_retirada_p IS NOT NULL AND nr_expurgo_retirada_p::text <> '') then
	update	cm_expurgo_retirada
	set	nr_conjunto_cont = nr_sequencia_w
	where	nr_sequencia = nr_expurgo_retirada_p;
end if;

if (nr_expurgo_receb_p IS NOT NULL AND nr_expurgo_receb_p::text <> '') then
	update	cm_expurgo_receb
	set	nr_conjunto_cont = nr_sequencia_w
	where	nr_sequencia = nr_expurgo_receb_p;
end if;


CALL cme_incluir_itens_controle(nr_sequencia_w,nm_usuario_barras_p);

/* commit nao e necessario, pois ja esta no cme_incluir_itens_controle */

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_gerar_item_cont_expurgo ( nr_seq_item_p bigint, nr_seq_ciclo_p bigint, nr_seq_lote_p bigint, nr_expurgo_retirada_p bigint, nr_expurgo_receb_p bigint, cd_setor_atendimento_p bigint, nm_usuario_barras_p text, cd_estabelecimento_p bigint) FROM PUBLIC;


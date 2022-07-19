-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_protocolo ( nr_seq_prestador_p bigint, dt_competencia_p timestamp, nr_seq_protocolo_p INOUT bigint, ie_tipo_protocolo_p bigint, nr_protocolo_prestador_p bigint, qt_max_contas_p bigint, cd_estabelecimento_p bigint, dt_protocolo_p timestamp, nm_usuario_p text, nr_seq_prot_referencia_p bigint, nr_seq_lote_p bigint, nr_seq_lote_apres_autom_P bigint, ie_commit_p text, ie_apresentacao_p text, dt_recebimento_p timestamp, ds_retorno_p INOUT text) AS $body$
DECLARE


/*
ie_tipo_protocolo_p
Segundo valores do dominio 1746
*/

/*incluído a consistência para verificar se o prestador ainda permite o envio de protocolos*/
				

ds_erro_w		varchar(255);
ie_apresentacao_w	varchar(10);
ds_tipo_erro_w		varchar(1) := 'A';
nr_seq_protocolo_w      bigint;
nr_seq_outorgante_w	bigint;
nr_seq_lote_w		bigint;
qt_max_contas_w		bigint;
dt_competencia_w	timestamp;
dt_competencia_prot_w	timestamp;
	

BEGIN
if (coalesce(ie_apresentacao_p::text, '') = '') then
	ie_apresentacao_w := 'A';
else
	ie_apresentacao_w := ie_apresentacao_p;
end if;

if (coalesce(nr_seq_lote_p,0) = 0 ) then
	nr_seq_lote_w := null;
else
	nr_seq_lote_w := nr_seq_lote_p;
end if;

if (coalesce(qt_max_contas_p,0) = 0) then
	qt_max_contas_w	 := null;
else
	qt_max_contas_w	:= qt_max_contas_p;
end if;

select	max(nr_sequencia)
into STRICT	nr_seq_outorgante_w
from    pls_outorgante
where   cd_estabelecimento = cd_estabelecimento_p;

dt_competencia_w	:= dt_competencia_p;

insert into pls_protocolo_conta(nr_sequencia, nm_usuario, dt_atualizacao,
        nm_usuario_nrec, dt_atualizacao_nrec, ie_situacao,
        ie_status, dt_mes_competencia, cd_estabelecimento,
        ie_tipo_guia, ie_apresentacao, dt_protocolo,
        nr_seq_prestador, nr_protocolo_prestador, qt_contas_informadas,
	dt_base_venc, ie_tipo_protocolo, nr_seq_prot_referencia,
	nr_seq_outorgante, ie_guia_fisica, nr_seq_lote_conta,
	ie_origem_protocolo, nr_seq_lote_apres_autom, dt_recebimento)
values (nextval('pls_protocolo_conta_seq'), nm_usuario_p, clock_timestamp(),
        nm_usuario_p, clock_timestamp(), 'D',
        1, dt_competencia_w, cd_estabelecimento_p,
        ie_tipo_protocolo_p, ie_apresentacao_w, dt_protocolo_p,
        nr_seq_prestador_p, nr_protocolo_prestador_p, qt_max_contas_w,
	clock_timestamp(), 'C', nr_seq_prot_referencia_p,
	nr_seq_outorgante_w, 'N', nr_seq_lote_w,
	'D', nr_seq_lote_apres_autom_p, coalesce(dt_recebimento_p,clock_timestamp())) returning nr_sequencia into nr_seq_protocolo_p;
	
/*necessário ser após para que seja realizada a correta consistência do protocolo*/

dt_competencia_w	:= pls_obter_dataref_prot_imp( 	nr_seq_prestador_p, 'D', dt_competencia_p,
							dt_protocolo_p, dt_recebimento_p, clock_timestamp(),
							ie_tipo_protocolo_p,nr_seq_protocolo_p, cd_estabelecimento_p);

update	pls_protocolo_conta
set	dt_mes_competencia	= dt_competencia_w
where	nr_sequencia		= nr_seq_protocolo_p;

SELECT * FROM pls_consistir_protocolo_conta(	nr_seq_prestador_p, null, to_date(dt_protocolo_p), ie_tipo_protocolo_p, dt_competencia_p, to_date(dt_protocolo_p), nr_protocolo_prestador_p, nr_seq_protocolo_p, qt_max_contas_p, nm_usuario_p, cd_estabelecimento_p, to_date(dt_recebimento_p), qt_max_contas_p, null, dt_competencia_prot_w, ds_tipo_erro_w, ds_erro_w) INTO STRICT dt_competencia_prot_w, ds_tipo_erro_w, ds_erro_w;
			
ds_retorno_p := ds_erro_w;

/*OS 404880 Diogo - adicionado o ie_commit_p para que não haja commit antes da finalização dos lotes de apresentação automática */

if (coalesce(ie_commit_p,'S')	= 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_protocolo ( nr_seq_prestador_p bigint, dt_competencia_p timestamp, nr_seq_protocolo_p INOUT bigint, ie_tipo_protocolo_p bigint, nr_protocolo_prestador_p bigint, qt_max_contas_p bigint, cd_estabelecimento_p bigint, dt_protocolo_p timestamp, nm_usuario_p text, nr_seq_prot_referencia_p bigint, nr_seq_lote_p bigint, nr_seq_lote_apres_autom_P bigint, ie_commit_p text, ie_apresentacao_p text, dt_recebimento_p timestamp, ds_retorno_p INOUT text) FROM PUBLIC;


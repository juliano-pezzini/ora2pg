-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_segurado_historico ( nr_seq_segurado_p bigint, ie_tipo_historico_p text, dt_historico_p timestamp, ds_historico_p text, ds_observacao_p text, dt_migracao_p timestamp, dt_reativacao_p timestamp, nr_seq_segurado_atual_p bigint, nr_seq_motivo_cancelamento_p bigint, dt_ocorrencia_sib_p timestamp, nr_seq_plano_ant_p bigint, nr_seq_contrato_ant_p bigint, nr_seq_titular_ant_p bigint, nr_seq_parentesco_ant_p text, nr_seq_vinculo_sca_p text, ds_parametro_tres_p text, nm_usuario_p text, ie_commit_p text) AS $body$
DECLARE


cd_cgc_estipulante_w		varchar(14);
cd_pf_estipulante_w		varchar(10);
nr_seq_subestipulante_w		bigint;
ie_tipo_segurado_w		varchar(3);
nr_seq_contrato_w		bigint;
nr_seq_seg_historico_w		bigint;
ds_observacao_w			varchar(4000);
ie_envio_sib_w			pls_segurado_historico.ie_envio_sib%type;


BEGIN

select	nr_seq_subestipulante,
	ie_tipo_segurado,
	nr_seq_contrato
into STRICT	nr_seq_subestipulante_w,
	ie_tipo_segurado_w,
	nr_seq_contrato_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
	select	cd_cgc_estipulante,
		cd_pf_estipulante
	into STRICT	cd_cgc_estipulante_w,
		cd_pf_estipulante_w
	from	pls_contrato
	where	nr_sequencia = nr_seq_contrato_w;
end if;

if (ie_tipo_historico_p in ('4','9','8','10','11','12','14','19','20','47','71','109')) then
	ie_envio_sib_w := 'S';
else
	ie_envio_sib_w := 'N';
end if;

select	nextval('pls_segurado_historico_seq')
into STRICT	nr_seq_seg_historico_w
;

ds_observacao_w := substr(ds_observacao_p, 1, 4000);

insert into pls_segurado_historico(nr_sequencia, dt_atualizacao, nm_usuario,
	dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_segurado,
	dt_historico, ds_historico, ds_observacao,
	dt_migracao, dt_reativacao, nr_seq_segurado_atual,
	nr_seq_motivo_cancelamento, ie_tipo_historico, dt_ocorrencia_sib,
	nr_seq_plano_ant, nr_seq_contrato_ant, nr_seq_titular_ant,
	cd_cgc_estipulante, cd_pf_estipulante, nr_seq_subestipulante,
	ie_historico_situacao, nr_seq_parentesco_ant, nr_seq_vinculo_sca,
	dt_liberacao_hist, ie_envio_sib, ie_situacao_compartilhamento)
values (	nr_seq_seg_historico_w, clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nm_usuario_p, nr_seq_segurado_p,
	dt_historico_p, ds_historico_p, ds_observacao_w,
	dt_migracao_p, dt_reativacao_p, nr_seq_segurado_atual_p,
	nr_seq_motivo_cancelamento_p, ie_tipo_historico_p, dt_ocorrencia_sib_p,
	nr_seq_plano_ant_p, nr_seq_contrato_ant_p, nr_seq_titular_ant_p,
	cd_cgc_estipulante_w, cd_pf_estipulante_w, nr_seq_subestipulante_w,
	'S', nr_seq_parentesco_ant_p, nr_seq_vinculo_sca_p,
	clock_timestamp(), ie_envio_sib_w, CASE WHEN ie_tipo_historico_p='102' THEN  'A'  ELSE 'I' END );

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_segurado_historico ( nr_seq_segurado_p bigint, ie_tipo_historico_p text, dt_historico_p timestamp, ds_historico_p text, ds_observacao_p text, dt_migracao_p timestamp, dt_reativacao_p timestamp, nr_seq_segurado_atual_p bigint, nr_seq_motivo_cancelamento_p bigint, dt_ocorrencia_sib_p timestamp, nr_seq_plano_ant_p bigint, nr_seq_contrato_ant_p bigint, nr_seq_titular_ant_p bigint, nr_seq_parentesco_ant_p text, nr_seq_vinculo_sca_p text, ds_parametro_tres_p text, nm_usuario_p text, ie_commit_p text) FROM PUBLIC;


-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_sinal_vital_pepo ( nr_cirurgia_p bigint, nm_usuario_p text, nr_seq_pepo_p bigint ) AS $body$
DECLARE


					
cd_estabelecimento_w   bigint := wheb_usuario_pck.get_cd_estabelecimento;
ie_grafico_modelo_w varchar(1);


BEGIN
ie_grafico_modelo_w := obter_param_usuario(872, 547, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_grafico_modelo_w);

insert into pepo_sv_cirurgia(
	nr_sequencia,
	nr_cirurgia,
	nr_seq_sinal_vital,
	ie_registra,
	nm_usuario,
	nr_seq_pepo)
SELECT	nextval('pepo_sv_cirurgia_seq'),
	nr_cirurgia_p,
	a.nr_sequencia,
	coalesce(obter_se_sv_padrao_proced(nr_cirurgia_p,nr_seq_pepo_p,a.nr_sequencia), coalesce(ie_padrao,'N')),
	nm_usuario_p,
	nr_seq_pepo_p
from	pepo_sv a
where  ((cd_estabelecimento = cd_estabelecimento_w) or (coalesce(cd_estabelecimento::text, '') = ''))
and (coalesce(ie_grafico_modelo_w, 'N') = 'S' or
a.nr_sequencia not in (SELECT b.nr_sequencia from pepo_sv b 
                        where b.nm_atributo in ('QT_CO2','QT_CLORO','QT_MG','QT_CA','QT_K','QT_NA','QT_SATO2','QT_LACTATO','QT_HT',
												'QT_HB','QT_BE','QT_HCO3','QT_PCO2','QT_PO2','QT_PH','QT_BIS_L','QT_BIS_R','QT_SQI_L',
												'QT_SQI_R','QT_EMG_L','QT_EMG_R','QT_SR_L','QT_SR_R','QT_SEF_L','QT_SEF_R', 'QT_TP_L',
												'QT_TP_R','QT_BURST_L','QT_BURST_R') 
and b.nm_tabela in ( 'ATEND_ANAL_BIOQ_PORT', 'ATEND_AVAL_ANALGESIA'))
)
and not exists(	select	1
			from	pepo_sv_cirurgia b
			where	((b.nr_cirurgia	=	nr_cirurgia_p AND nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') or (b.nr_seq_pepo = nr_seq_pepo_p AND nr_seq_pepo_p IS NOT NULL AND nr_seq_pepo_p::text <> ''))
			and	b.nm_usuario	=	nm_usuario_p
			and	b.nr_seq_sinal_vital = 	a.nr_sequencia);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_sinal_vital_pepo ( nr_cirurgia_p bigint, nm_usuario_p text, nr_seq_pepo_p bigint ) FROM PUBLIC;

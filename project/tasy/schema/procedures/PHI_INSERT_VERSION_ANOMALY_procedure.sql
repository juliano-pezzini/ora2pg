-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE phi_insert_version_anomaly ( nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type, cd_versao_inicial_p text, nm_usuario_p text ) AS $body$
DECLARE


nr_seq_intencao_uso_w	man_ordem_servico.nr_seq_intencao_uso%type;

c01 CURSOR FOR
	SELECT	distinct
		atv.cd_versao
	from	aplicacao_tasy_versao atv
	where	atv.cd_versao >= cd_versao_inicial_p
	and	((nr_seq_intencao_uso_w = atv.nr_seq_intencao_uso) or (coalesce(nr_seq_intencao_uso_w::text, '') = '' and atv.nr_seq_intencao_uso = 2))
	and	atv.cd_versao not in (
						SELECT	psma.ds_version
						from	phi_so_market_anomaly psma
						where	psma.nr_seq_service_order = nr_seq_ordem_serv_p
					)
	order by 1 desc;

BEGIN
	
	select	coalesce(max(nr_seq_intencao_uso), 2) nr_seq_intencao_uso
	into STRICT	nr_seq_intencao_uso_w
	from	man_ordem_servico
	where	nr_sequencia = nr_seq_ordem_serv_p;

	if (nr_seq_ordem_serv_p IS NOT NULL AND nr_seq_ordem_serv_p::text <> '') then
		begin
			for reg in c01 loop
			begin
				insert into phi_so_market_anomaly(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_service_order,
					ie_receive_version_pass,
					nr_seq_justif,
					ds_version)
				 values (
					nextval('phi_so_market_anomaly_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_ordem_serv_p,
					'S',
					null,
					reg.cd_versao);
			end;
			end loop;
			commit;
		end;
	end if;	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE phi_insert_version_anomaly ( nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type, cd_versao_inicial_p text, nm_usuario_p text ) FROM PUBLIC;

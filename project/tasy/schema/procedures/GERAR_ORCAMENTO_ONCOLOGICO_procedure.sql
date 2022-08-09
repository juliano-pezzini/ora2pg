-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_orcamento_oncologico ( cd_protocolo_p bigint, nr_sequencia_p bigint, nr_sequencia_orcamento_p bigint, nm_usuario_p text, nr_seq_paciente_p bigint default null, nr_seq_tratamento_p bigint default null) AS $body$
BEGIN

if (coalesce(nr_seq_tratamento_p::text, '') = '')	then
	--Copiar dados protocolo
	CALL copiar_protocolo_onc_orcamento(cd_protocolo_p, nr_sequencia_p, nr_sequencia_orcamento_p, nm_usuario_p, nr_seq_paciente_p);
else
	--Copiar dados tratamento
	CALL copiar_rxt_tratamento_onc_orc(nr_sequencia_orcamento_p, nr_seq_tratamento_p, nm_usuario_p);
end if;

--Atualizar dose oncologica
CALL atualizar_dose_onc_orcamento(nr_sequencia_orcamento_p, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_orcamento_oncologico ( cd_protocolo_p bigint, nr_sequencia_p bigint, nr_sequencia_orcamento_p bigint, nm_usuario_p text, nr_seq_paciente_p bigint default null, nr_seq_tratamento_p bigint default null) FROM PUBLIC;

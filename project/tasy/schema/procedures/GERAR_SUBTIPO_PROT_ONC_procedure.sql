-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_subtipo_prot_onc ( cd_protocolo_p bigint, ds_subtipo_p text, nr_seq_paciente_p bigint, ie_copia_sol_p text, ie_copia_med_p text, ie_copia_proc_exa_p text, ie_copia_rec_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;


BEGIN
select	coalesce(max(nr_sequencia),0) + 1
into STRICT	nr_sequencia_w
from	protocolo_medicacao
where	coalesce(cd_protocolo,cd_protocolo_p) = cd_protocolo_p;

if (coalesce(nr_sequencia_w,0) > 0) and (coalesce(cd_protocolo_p,0) > 0) and ((trim(both ds_subtipo_p) IS NOT NULL AND (trim(both ds_subtipo_p))::text <> '')) then

	insert into protocolo_medicacao(
				nr_seq_interna,
				cd_protocolo,
				ie_situacao,
				nm_medicacao,
				nr_ciclos,
				nr_sequencia)
			values (
				nextval('protocolo_medicacao_seq'),
				cd_protocolo_p,
				'A',
				substr(ds_subtipo_p,1,255),
				1,
				nr_sequencia_w);
	commit;

	CALL gerar_protocolo_onc(cd_protocolo_p, nr_sequencia_w, nr_seq_paciente_p, ie_copia_sol_p, ie_copia_med_p, ie_copia_proc_exa_p, ie_copia_rec_p, nm_usuario_p);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_subtipo_prot_onc ( cd_protocolo_p bigint, ds_subtipo_p text, nr_seq_paciente_p bigint, ie_copia_sol_p text, ie_copia_med_p text, ie_copia_proc_exa_p text, ie_copia_rec_p text, nm_usuario_p text) FROM PUBLIC;

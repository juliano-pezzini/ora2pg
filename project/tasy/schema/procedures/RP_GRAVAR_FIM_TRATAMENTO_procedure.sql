-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rp_gravar_fim_tratamento (nr_seq_tratamento_p bigint, nr_seq_motivo_p bigint, dt_data_fim_p timestamp, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_pac_reab_final_w	bigint;
nr_seq_pac_reab_w	bigint;
ie_altera_status_final_w	varchar(1);


BEGIN
ie_altera_status_final_w := Obter_param_Usuario(9091, 37, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_altera_status_final_w);

select	max(nr_seq_pac_reab_final)
into STRICT	nr_seq_pac_reab_final_w
from	rp_parametros
where	cd_estabelecimento = cd_estabelecimento_p;

if (nr_seq_motivo_p > 0) then
	update 	rp_tratamento
	set	dt_fim_tratamento 		= dt_data_fim_p,
		nr_seq_motivo_fim_trat	= nr_seq_motivo_p,
		nr_seq_status 		= CASE WHEN ie_altera_status_final_w='S' THEN nr_seq_pac_reab_final_w  ELSE nr_seq_status END
	where	nr_sequencia 		= nr_seq_tratamento_p;

	commit;

end if;

if (nr_seq_pac_reab_final_w IS NOT NULL AND nr_seq_pac_reab_final_w::text <> '') then

	select	max(nr_seq_pac_reav)
	into STRICT	nr_seq_pac_reab_w
	from	rp_tratamento
	where	nr_sequencia 	= nr_seq_tratamento_p;

	update 	rp_paciente_reabilitacao
	set	nr_seq_status	= nr_seq_pac_reab_final_w
	where	nr_sequencia 	= nr_seq_pac_reab_w;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rp_gravar_fim_tratamento (nr_seq_tratamento_p bigint, nr_seq_motivo_p bigint, dt_data_fim_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;


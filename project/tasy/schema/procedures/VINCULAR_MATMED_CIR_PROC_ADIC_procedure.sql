-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_matmed_cir_proc_adic (nr_seq_matpaci_p bigint, nr_seq_propaci_p bigint, nm_usuario_p text) AS $body$
DECLARE



dt_procedimento_w	timestamp;


BEGIN

select	max(dt_procedimento)
into STRICT	dt_procedimento_w
from	procedimento_paciente
where	nr_sequencia	= nr_seq_propaci_p;

update	material_atend_paciente
set	dt_atendimento		= dt_procedimento_w,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p,
	nr_seq_proc_princ	= nr_seq_propaci_p
where	nr_sequencia		= nr_seq_matpaci_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_matmed_cir_proc_adic (nr_seq_matpaci_p bigint, nr_seq_propaci_p bigint, nm_usuario_p text) FROM PUBLIC;

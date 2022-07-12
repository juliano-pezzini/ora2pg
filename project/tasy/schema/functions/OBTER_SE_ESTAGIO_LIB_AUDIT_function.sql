-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_estagio_lib_audit ( nr_seq_auditoria_p auditoria_conta_paciente.nr_sequencia%type, nr_seq_motivo_audit_p auditoria_motivo.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


nr_seq_pendencia_w	cta_pendencia.nr_sequencia%type;
nr_seq_estagio_w	cta_pendencia.nr_seq_estagio%type;
qt_regra_w		bigint;
qt_regra_motivo_w	bigint;
ds_retorno_w		varchar(1) := 'S';


BEGIN

if (coalesce(nr_seq_auditoria_p,0) > 0) then

	select	count(1)
	into STRICT	qt_regra_w
	from	auditoria_motivo_estagio
	where	nr_seq_audit_motivo = nr_seq_motivo_audit_p;

	if (qt_regra_w > 0) then

		select	max(nr_sequencia)
		into STRICT	nr_seq_pendencia_w
		from	cta_pendencia
		where	nr_seq_auditoria = nr_seq_auditoria_p;

		if (coalesce(nr_seq_pendencia_w,0) > 0) then

			select	max(nr_seq_estagio)
			into STRICT	nr_seq_estagio_w
			from	cta_pendencia
			where	nr_sequencia = nr_seq_pendencia_w;

			select	count(1)
			into STRICT	qt_regra_motivo_w
			from	auditoria_motivo_estagio
			where	nr_seq_audit_motivo = nr_seq_motivo_audit_p
			and	nr_seq_estagio_pend = nr_seq_estagio_w;

			if (qt_regra_motivo_w = 0) then
				ds_retorno_w	:= 'N';
			end if;

		end if;

	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_estagio_lib_audit ( nr_seq_auditoria_p auditoria_conta_paciente.nr_sequencia%type, nr_seq_motivo_audit_p auditoria_motivo.nr_sequencia%type) FROM PUBLIC;


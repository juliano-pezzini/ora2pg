-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_pacote_conta ( nr_interno_conta_p bigint, cd_setor_atendimento_p bigint, nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		double precision := 0;
nr_seq_proc_pacote_w	bigint;


C01 CURSOR FOR
	SELECT	coalesce(nr_seq_proc_pacote,0)
	from	procedimento_paciente
	where	nr_interno_conta = nr_interno_conta_p
	group by nr_seq_proc_pacote;

C02 CURSOR FOR
	SELECT	coalesce(nr_seq_proc_pacote,0)
	from	procedimento_paciente
	where	cd_setor_atendimento = cd_setor_atendimento_p
	and 	nr_atendimento = nr_atendimento_p
	and 	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
	group by nr_seq_proc_pacote;

C03 CURSOR FOR
	SELECT	coalesce(nr_seq_proc_pacote,0)
	from	procedimento_paciente
	where	nr_atendimento = nr_atendimento_p
	and 	(nr_interno_conta IS NOT NULL AND nr_interno_conta::text <> '')
	group by nr_seq_proc_pacote;




BEGIN
if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then
	open C01;
	loop
	fetch C01 into
		nr_seq_proc_pacote_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (nr_seq_proc_pacote_w > 0) then
			vl_retorno_w:= vl_retorno_w + coalesce(obter_valor_pacote(nr_seq_proc_pacote_w),0);
		end if;
		end;
	end loop;
	close C01;
elsif (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') then
	open C02;
	loop
	fetch C02 into
		nr_seq_proc_pacote_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (nr_seq_proc_pacote_w > 0) then
			vl_retorno_w:= vl_retorno_w +  coalesce(obter_valor_pacote(nr_seq_proc_pacote_w),0);
		end if;
		end;
	end loop;
	close C02;
elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	open C03;
	loop
	fetch C03 into
		nr_seq_proc_pacote_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		if (nr_seq_proc_pacote_w > 0) then
			vl_retorno_w:= vl_retorno_w +  coalesce(obter_valor_pacote(nr_seq_proc_pacote_w),0);
		end if;
		end;
	end loop;
	close C03;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_pacote_conta ( nr_interno_conta_p bigint, cd_setor_atendimento_p bigint, nr_atendimento_p bigint) FROM PUBLIC;

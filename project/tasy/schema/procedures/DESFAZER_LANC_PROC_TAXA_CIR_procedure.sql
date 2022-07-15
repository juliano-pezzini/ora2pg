-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_lanc_proc_taxa_cir ( nr_cirurgia_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_propaci_w	bigint;
cd_motivo_exc_conta_w	bigint;
nr_conta_fechada_w	conta_paciente.nr_interno_conta%type;


BEGIN

begin

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_propaci_w
from	procedimento_paciente
where	nr_cirurgia = nr_cirurgia_p
and	coalesce(nr_seq_regra_taxa_cir,0) > 0;

if (nr_seq_propaci_w > 0) then

	select	count(*)
	into STRICT	nr_conta_fechada_w
	from	procedimento_paciente a,
		conta_paciente b
	where	a.nr_interno_conta = b.nr_interno_conta
	and	a.nr_sequencia = nr_seq_propaci_w
	and	b.ie_status_acerto = 2;

	if (nr_conta_fechada_w = 0) then

		select 	max(cd_motivo_exc_conta)
		into STRICT	cd_motivo_exc_conta_w
		from   	parametro_faturamento
		where  	cd_estabelecimento = cd_estabelecimento_p;

		update	procedimento_paciente
		set 	nr_interno_conta 	 = NULL,
			cd_motivo_exc_conta 	= cd_motivo_exc_conta_w,
			nr_cirurgia 		 = NULL
		where	nr_sequencia = nr_seq_propaci_w;

	end if;

end if;
exception
	when others then
	cd_motivo_exc_conta_w := 0;
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_lanc_proc_taxa_cir ( nr_cirurgia_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;


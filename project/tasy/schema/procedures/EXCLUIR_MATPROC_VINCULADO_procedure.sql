-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_matproc_vinculado (nr_seq_mat_origem_p bigint) AS $body$
DECLARE

 
cont_mat_w		bigint;
cont_proc_w		bigint;
nr_seq_proc_rla_w		bigint;
nr_seq_mat_rla_w		bigint;

C01 CURSOR FOR 
	SELECT	nr_seq_proc_rla, 
		nr_seq_mat_rla 
	from	material_vinc_rla 
	where	nr_seq_mat_origem = nr_seq_mat_origem_p;
	

BEGIN 
 
select	count(*) 
into STRICT	cont_mat_w 
from	material_vinc_rla a, 
	material_atend_paciente b, 
	conta_paciente c 
where	a.nr_seq_mat_rla = b.nr_sequencia 
and	b.nr_interno_conta = c.nr_interno_conta 
and	nr_seq_mat_origem = nr_seq_mat_origem_p 
and	c.ie_status_acerto = 2;
 
select	count(*) 
into STRICT	cont_proc_w 
from	material_vinc_rla a, 
	procedimento_paciente b, 
	conta_paciente c 
where	a.nr_seq_proc_rla = b.nr_sequencia 
and	b.nr_interno_conta = c.nr_interno_conta 
and	nr_seq_mat_origem = nr_seq_mat_origem_p 
and	c.ie_status_acerto = 2;
 
if (cont_proc_w = 0) and (cont_mat_w = 0) then 
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_proc_rla_w, 
		nr_seq_mat_rla_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		if (nr_seq_mat_rla_w IS NOT NULL AND nr_seq_mat_rla_w::text <> '') then 
			delete	from material_atend_paciente 
			where	nr_sequencia = nr_seq_mat_rla_w;
		end if;
		if (nr_seq_proc_rla_w IS NOT NULL AND nr_seq_proc_rla_w::text <> '') then 
			delete	from procedimento_paciente 
			where	nr_sequencia = nr_seq_proc_rla_w;
		end if;
		end;
	end loop;
	close C01;
	 
	delete	from material_vinc_rla 
	where	nr_seq_mat_origem = nr_seq_mat_origem_p;
		 
else 
	/*r.aise_application_error(-20011, 'Não é possível excluir este material!' || chr(13) || 
					'Existem materiais ou procedimentos dependentes em contas definitivas.');*/
 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263316);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_matproc_vinculado (nr_seq_mat_origem_p bigint) FROM PUBLIC;

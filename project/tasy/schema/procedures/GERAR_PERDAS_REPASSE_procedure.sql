-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_perdas_repasse (nr_interno_conta_p bigint, nm_usuario_p text, ie_operacao_p text, vl_titulo_p bigint DEFAULT 0, vl_baixa_p bigint DEFAULT 0, vl_saldo_titulo_p bigint DEFAULT 0) AS $body$
DECLARE


/* NÃO DAR COMMIT NESTA PROCEDURE */

nr_seq_repasse_w		bigint;
ie_forma_pagto_w		varchar(1);
ie_status_w		varchar(1);
ie_tipo_item_w		varchar(1);
vl_porcentagem_perda_w		double precision;
vl_procmat_repasse_w		double precision := 0;
nr_seq_novo_proc_w		procedimento_repasse.nr_sequencia%type;
nr_seq_novo_mat_w		material_repasse.nr_sequencia%type;

c01 CURSOR FOR
SELECT	'P' ie_tipo_item,
	b.nr_sequencia,
	c.ie_forma_pagto
from	terceiro c,
	procedimento_repasse b,
	procedimento_paciente a
where	b.nr_seq_terceiro		= c.nr_sequencia
and	coalesce(b.nr_repasse_terceiro::text, '') = ''
and	a.nr_sequencia		= b.nr_seq_procedimento
and	a.nr_interno_conta		= nr_interno_conta_p
and	b.ie_status = 'A'

union all

SELECT	'M' ie_tipo_item,
	b.nr_sequencia,
	c.ie_forma_pagto
from	terceiro c,
	material_repasse b,
	material_atend_paciente a
where	b.nr_seq_terceiro		= c.nr_sequencia
and	coalesce(b.nr_repasse_terceiro::text, '') = ''
and	a.nr_sequencia		= b.nr_seq_material
and	a.nr_interno_conta		= nr_interno_conta_p
and	b.ie_status = 'A';


BEGIN

open	c01;
loop
fetch	c01 into
	ie_tipo_item_w,
	nr_seq_repasse_w,
	ie_forma_pagto_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (ie_operacao_p = 'B') then
		ie_status_w	:= 'P';
	elsif (ie_forma_pagto_w = 'P') then
		ie_status_w	:= 'U';
	else
		ie_status_w	:= 'A';
	end if;
	
	if (vl_titulo_p = 0 and vl_baixa_p = 0) then
		vl_porcentagem_perda_w	:= 1;
	else
		vl_porcentagem_perda_w := dividir_sem_round(vl_baixa_p,vl_titulo_p);
		select CASE WHEN vl_porcentagem_perda_w=0 THEN 1  ELSE vl_porcentagem_perda_w END
		into STRICT vl_porcentagem_perda_w;
	end if;
	
	if (ie_tipo_item_w	= 'P') then

		select	vl_original_repasse * (1 - vl_porcentagem_perda_w)
		into STRICT	vl_procmat_repasse_w
		from	procedimento_repasse
		where	nr_sequencia	= nr_seq_repasse_w;
		
		update	procedimento_repasse a
		set	a.ie_status	= ie_status_w,
			a.nm_usuario	= nm_usuario_p,
			vl_repasse		= vl_original_repasse * vl_porcentagem_perda_w
		where	a.nr_sequencia	= nr_seq_repasse_w;

		if (vl_procmat_repasse_w > 0) and (vl_saldo_titulo_p > 0) then
			SELECT * FROM Desdobrar_ProcMat_Repasse(nr_seq_repasse_w, null, 'A', vl_procmat_repasse_w, nm_usuario_p, nr_seq_novo_proc_w, nr_seq_novo_mat_w) INTO STRICT nr_seq_novo_proc_w, nr_seq_novo_mat_w;
		end if;

	else

		select	vl_original_repasse * (1 - vl_porcentagem_perda_w)
		into STRICT		vl_procmat_repasse_w
		from		material_repasse
		where	nr_sequencia	= nr_seq_repasse_w;

		update	material_repasse a
		set	a.ie_status	= ie_status_w,
			a.nm_usuario	= nm_usuario_p,
			vl_repasse		= vl_original_repasse * vl_porcentagem_perda_w
		where	a.nr_sequencia	= nr_seq_repasse_w;

		if (vl_procmat_repasse_w > 0) and (vl_saldo_titulo_p > 0)  then
			SELECT * FROM Desdobrar_ProcMat_Repasse(null, nr_seq_repasse_w, 'A', vl_procmat_repasse_w, nm_usuario_p, nr_seq_novo_proc_w, nr_seq_novo_mat_w) INTO STRICT nr_seq_novo_proc_w, nr_seq_novo_mat_w;
		end if;

	end if;

end	loop;
close	c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_perdas_repasse (nr_interno_conta_p bigint, nm_usuario_p text, ie_operacao_p text, vl_titulo_p bigint DEFAULT 0, vl_baixa_p bigint DEFAULT 0, vl_saldo_titulo_p bigint DEFAULT 0) FROM PUBLIC;


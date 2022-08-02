-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_dupl_proc_rol ( nr_seq_rol_p bigint, nr_seq_rol_grupo_proc_p bigint, nr_seq_rol_proc_p bigint, ie_origem_proced_p bigint, cd_procedimento_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


qt_inconsistencias_w		bigint;

--Verifica se o procedimento a ser criado já existe dentro do rol de procedimentos, se sim passa uma mensagem de erro para o parâmetro de saída.
BEGIN
ds_erro_p 	:= '';
select	count(1)
into STRICT	qt_inconsistencias_w
from	pls_rol_procedimento	a,
	pls_rol_grupo_proc	b,
	pls_rol_subgrupo	c,
	pls_rol_grupo		d,
	pls_rol_capitulo	e,
	pls_rol			f
where	a.nr_seq_rol_grupo	= b.nr_sequencia
and	b.nr_seq_subgrupo	= c.nr_sequencia
and	c.nr_seq_grupo		= d.nr_sequencia
and	d.nr_seq_capitulo	= e.nr_sequencia
and	e.nr_seq_rol		= f.nr_sequencia
and	f.nr_sequencia		= nr_seq_rol_p
and	a.cd_procedimento	= cd_procedimento_p
and	a.nr_sequencia		<> nr_seq_rol_proc_p
and	a.ie_origem_proced	= ie_origem_proced_p
and (b.nr_sequencia = nr_seq_rol_grupo_proc_p or coalesce(nr_seq_rol_grupo_proc_p,0) = 0);

if (qt_inconsistencias_w > 0) then
	ds_erro_p	:= wheb_mensagem_pck.get_texto(280845);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_dupl_proc_rol ( nr_seq_rol_p bigint, nr_seq_rol_grupo_proc_p bigint, nr_seq_rol_proc_p bigint, ie_origem_proced_p bigint, cd_procedimento_p bigint, ds_erro_p INOUT text) FROM PUBLIC;


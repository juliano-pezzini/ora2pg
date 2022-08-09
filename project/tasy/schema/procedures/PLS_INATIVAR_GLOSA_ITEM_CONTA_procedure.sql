-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inativar_glosa_item_conta ( nr_seq_glosa_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
qt_conta_glosa_w		bigint;
vl_glosa_W			bigint;
nr_seq_conta_w			bigint;


BEGIN

select	nr_seq_conta_proc,
	nr_seq_conta_mat,
	nr_seq_conta
into STRICT	nr_seq_conta_proc_w,
	nr_seq_conta_mat_w,
	nr_seq_conta_w
from	pls_conta_glosa
where	nr_sequencia = nr_seq_glosa_p;

select	count(1)
into STRICT	qt_conta_glosa_w
from	pls_conta_glosa
where	nr_seq_conta	= nr_seq_conta_w;

if (coalesce(nr_seq_conta_proc_w,0) <> 0 ) then
	select	vl_glosa
	into STRICT	vl_glosa_w
	from	pls_conta_proc
	where	nr_sequencia = nr_seq_conta_proc_w;

	select	count(1)
	into STRICT	qt_conta_glosa_w
	from	pls_conta_glosa
	where	nr_seq_conta_proc = nr_seq_conta_proc_w
	and	ie_situacao = 'A';

	if (vl_glosa_w  > 0) and (qt_conta_glosa_w <= 1) then
		--'Procedimento possui valor de glosa, deve existir pelo menos uma glosa ativa para esse item. #@#@');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(213557);
	end if;
elsif (coalesce(nr_seq_conta_mat_w,0) <> 0) then
	select	vl_glosa
	into STRICT	vl_glosa_w
	from	pls_conta_mat
	where	nr_sequencia = nr_seq_conta_mat_w;

	select	count(1)
	into STRICT	qt_conta_glosa_w
	from	pls_conta_glosa
	where	nr_seq_conta_mat = nr_seq_conta_mat_w
	and	ie_situacao = 'A';

	if (vl_glosa_w  > 0) and (qt_conta_glosa_w <= 1) then
		--'Material possui valor de glosa, deve existir pelo menos uma glosa ativa para esse item. #@#@');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(213558);
	end if;
end if;

if (qt_conta_glosa_w >= 1) then
	update	pls_ocorrencia_benef
	set	ie_situacao = 'I'
	where	nr_seq_glosa = nr_seq_glosa_p;

	update	pls_conta_glosa
	set	ie_situacao = 'I'
	where	nr_sequencia = nr_seq_glosa_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inativar_glosa_item_conta ( nr_seq_glosa_p bigint, nm_usuario_p text) FROM PUBLIC;

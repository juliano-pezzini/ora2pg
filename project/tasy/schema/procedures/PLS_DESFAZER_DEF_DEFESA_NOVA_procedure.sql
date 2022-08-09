-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_def_defesa_nova ( nr_seq_defesa_p pls_formulario_defesa.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_formulario_w		pls_formulario.nr_sequencia%type;
ie_tipo_peticao_w		pls_formulario.ie_tipo_peticao%type;
nr_seq_conta_w			pls_processo_conta.nr_sequencia%type;
qt_registro_w			integer;


BEGIN
select	max(fd.nr_seq_formulario),
	max(f.ie_tipo_peticao),
	max(f.nr_seq_conta)
into STRICT	nr_seq_formulario_w,
	ie_tipo_peticao_w,
	nr_seq_conta_w
from	pls_formulario_defesa	fd,
	pls_formulario		f
where	f.nr_sequencia	= fd.nr_seq_formulario
and	fd.nr_sequencia	= nr_seq_defesa_p;

if (ie_tipo_peticao_w = '1') then
	select	count(1)
	into STRICT	qt_registro_w
	from	pls_formulario
	where	nr_seq_conta	= nr_seq_conta_w
	and	ie_tipo_peticao	= '2';

	if (qt_registro_w > 0) then
		-- Não é possível desfazer retorno da defesa de impugnação caso tenha recurso cadastrado.
		CALL wheb_mensagem_pck.exibir_mensagem_abort(822855);
	end if;
end if;

update	pls_formulario_defesa
set	ie_status		= 'A',
	ds_oficio		 = NULL,
	ds_motivo_deferimento	 = NULL,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_defesa_p;

if (nr_seq_formulario_w IS NOT NULL AND nr_seq_formulario_w::text <> '') then
	update	pls_formulario
	set	ie_status_impugnacao	= CASE WHEN ie_tipo_peticao_w='1' THEN 'E'  ELSE 'C' END ,
		vl_ressarcir		= 0,
		vl_deferido		= 0
	where	nr_sequencia		= nr_seq_formulario_w;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_def_defesa_nova ( nr_seq_defesa_p pls_formulario_defesa.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

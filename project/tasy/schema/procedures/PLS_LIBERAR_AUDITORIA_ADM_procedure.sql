-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_auditoria_adm ( nr_seq_guia_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_glosa_w			varchar(1)	:= 'N';
ie_estagio_w			smallint;
qt_guia_proc_auditoria_w	integer	:= 0;
ds_mensagem_auditoria_w		varchar(255);
nr_seq_regra_liberacao_w	bigint;


BEGIN

ie_glosa_w	:= pls_obter_se_guia_glosada(nr_seq_guia_p);

select	count(*)
into STRICT	qt_guia_proc_auditoria_w
from	pls_guia_plano_proc
where	nr_seq_guia	= nr_seq_guia_p
and	coalesce(nr_seq_regra_liberacao,0)	> 0;

if (ie_glosa_w	= 'S') then
	ie_estagio_w	:= 2; /* Consistido com glosa */
elsif (qt_guia_proc_auditoria_w > 0) then
	ie_estagio_w	:= 1; /*  Em auditoria */
elsif (ie_glosa_w	= 'N') then
	ie_estagio_w	:= 3; /*  Consisitido sem glosa*/
end if;

begin
select	substr(pls_obter_mensagem_auditoria(nr_sequencia, 'G'),1,255),
	nr_seq_regra_liberacao
into STRICT	ds_mensagem_auditoria_w,
	nr_seq_regra_liberacao_w
from	pls_guia_plano
where	nr_sequencia	= nr_seq_guia_p;
exception
	when others then
	ds_mensagem_auditoria_w		:= '';
	nr_seq_regra_liberacao_w	:= null;
end;

update	pls_guia_plano
set	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	nr_seq_regra_liberacao	 = NULL,
	ie_estagio		= ie_estagio_w,
	ie_status		= '2'
where	nr_sequencia		= nr_seq_guia_p
and	ie_estagio		= 1;

CALL pls_guia_gravar_historico(nr_seq_guia_p, 1, 'Mensagem: ' || ds_mensagem_auditoria_w ||
	' / Regra auditoria: ' || nr_seq_regra_liberacao_w || ' / Estágio: ' || ie_estagio_w ||
	' / Glosa: ' || ie_glosa_w, null, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_auditoria_adm ( nr_seq_guia_p bigint, nm_usuario_p text) FROM PUBLIC;

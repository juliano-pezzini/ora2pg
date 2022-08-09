-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_guia_manual ( nr_seq_guia_p bigint, nr_seq_motivo_lib_p bigint, ds_observacao_p text, qt_dia_autorizado_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_dia_autorizado_w		integer;
nr_seq_segurado_w		bigint;
dt_solicitacao_w		timestamp;
ie_tipo_guia_w			varchar(2);
dt_valid_senha_w		varchar(20);
cd_senha_w			varchar(20);
qt_dias_validade_w		integer;
qt_itens_w			bigint;
ie_estagio_w			bigint;
qt_registros_w			bigint;
nr_seq_atend_pls_w		bigint;
nr_seq_evento_atend_w		bigint;
dt_fim_evento_w			timestamp;
ie_status_w			varchar(1);


BEGIN

select	sum(qt_guia_item)
into STRICT	qt_itens_w
from (SELECT	count(1) qt_guia_item
	from	pls_guia_plano_proc
	where	nr_seq_guia = nr_seq_guia_p
	
union

	SELECT	count(1) qt_guia_item
	from	pls_guia_plano_mat
	where	nr_seq_guia = nr_seq_guia_p) alias3;

if (qt_itens_w = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(191838);
	--'Guia nao pode ser liberada. Deve existir pelo menos um procedimento ou material informado para a guia.'
end if;

insert into pls_guia_motivo_lib(nr_sequencia, dt_atualizacao, nm_usuario,
	dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_motivo,
	nr_seq_guia, ds_observacao, nm_usuario_liberacao, 
	dt_liberacao, nr_seq_guia_proc, nr_seq_guia_mat, 
	ie_auditoria)
values (nextval('pls_guia_motivo_lib_seq'), clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nm_usuario_p, nr_seq_motivo_lib_p,
	nr_seq_guia_p, substr(ds_observacao_p,1,4000), nm_usuario_p,
	clock_timestamp(), null, null,
	null);
	
begin
	select	nr_seq_segurado,
		dt_solicitacao,
		ie_tipo_guia,
		ie_estagio
	into STRICT	nr_seq_segurado_w,
		dt_solicitacao_w,
		ie_tipo_guia_w,
		ie_estagio_w
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_p;
exception
when others then
	nr_seq_segurado_w 	:= null;
	dt_solicitacao_w	:= null;
	ie_tipo_guia_w		:= null;
	ie_estagio_w		:= 0;
end;

qt_dias_validade_w := (obter_valor_param_usuario(1204, 3, Obter_Perfil_Ativo, nm_usuario_p, 0))::numeric;

SELECT * FROM pls_gerar_validade_senha(nr_seq_guia_p, nr_seq_segurado_w, qt_dias_validade_w, dt_solicitacao_w, ie_tipo_guia_w, nm_usuario_p, dt_valid_senha_w, cd_senha_w) INTO STRICT dt_valid_senha_w, cd_senha_w;

select	count(1)
into STRICT	qt_registros_w
from	pls_auditoria
where	nr_seq_guia	= nr_seq_guia_p
and	coalesce(dt_liberacao::text, '') = ''
and	ie_status	<> 'F';

if (qt_registros_w	> 0) then
	update	pls_auditoria
	set	ie_status	= 'F',
		dt_liberacao	= clock_timestamp(),
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_seq_guia	= nr_seq_guia_p;
end if;

update	pls_guia_plano_proc
set	ie_status		= 'L',
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p,
	qt_autorizada		= qt_solicitada,
	dt_liberacao		= clock_timestamp(),
	nm_usuario_liberacao	= nm_usuario_p
where	nr_seq_guia		= nr_seq_guia_p
and	(cd_procedimento IS NOT NULL AND cd_procedimento::text <> '');

update	pls_guia_plano_mat
set	ie_status		= 'L',
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p,
	qt_autorizada		= qt_solicitada,
	dt_liberacao		= clock_timestamp(),
	nm_usuario_liberacao	= nm_usuario_p
where	nr_seq_guia		= nr_seq_guia_p
and	(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');

update	pls_guia_plano
set	ie_status		= '1',
	ie_estagio		= 5,
	nr_seq_motivo_lib	= nr_seq_motivo_lib_p,
	cd_senha		= cd_senha_w,
	dt_validade_senha	= to_date(dt_valid_senha_w, 'dd/mm/rrrr'),
	dt_autorizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_guia_p;

begin
select	nr_seq_atend_pls,
	nr_seq_evento_atend
into STRICT	nr_seq_atend_pls_w,
	nr_seq_evento_atend_w
from	pls_guia_plano
where	nr_sequencia = nr_seq_guia_p;
exception
when others then
	nr_seq_atend_pls_w := null;
end;

begin
select	dt_fim_evento
into STRICT	dt_fim_evento_w
from	pls_atendimento_evento
where	nr_sequencia = nr_seq_evento_atend_w;
exception
when others then
	dt_fim_evento_w := null;
end;
				
if (nr_seq_atend_pls_w IS NOT NULL AND nr_seq_atend_pls_w::text <> '') and (dt_fim_evento_w IS NOT NULL AND dt_fim_evento_w::text <> '') then	
	
CALL pls_finalizar_atendimento(	nr_seq_atend_pls_w,
				nr_seq_evento_atend_w,
				null,
				null,
				nm_usuario_p);
end if;

CALL pls_atualiza_estagio_guia_conv(nr_seq_guia_p,nm_usuario_p);

select	ie_estagio
into STRICT	ie_estagio_w
from	pls_guia_plano
where	nr_sequencia	= nr_seq_guia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_guia_manual ( nr_seq_guia_p bigint, nr_seq_motivo_lib_p bigint, ds_observacao_p text, qt_dia_autorizado_p bigint, nm_usuario_p text) FROM PUBLIC;

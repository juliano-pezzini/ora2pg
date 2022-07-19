-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_substituir_aih_unif ( nr_interno_conta_p bigint, nr_aih_nova_p bigint, nm_usuario_p text, ie_consiste_aih_p text) AS $body$
DECLARE



nr_aih_antiga_w		bigint;
nr_seq_aih_antiga_w	bigint;
nr_aih_nova_w		bigint;
nr_seq_aih_nova_w	bigint;
nr_atendimento_w	bigint;
nr_interno_conta_w	bigint;
ie_digito_aih_w		varchar(1);
qt_registro_w		bigint;
qt_registro_total_w	bigint;
ds_erro_w		varchar(255);
qt_reg_controle_w	bigint	:= 0;



BEGIN

nr_aih_nova_w	:= nr_aih_nova_p;

/* consiste digito nova AIH */

select 	consistir_digito('AIH',to_char(nr_aih_nova_p))
into STRICT	ie_digito_aih_w
;
if (ie_consiste_aih_p	= 'S') and (ie_digito_aih_w	= 'N') then	
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263566); --Nova AIH nao informada ou com digito invalido
end if;

/* busca dados da AIH antiga */

select	coalesce(max(nr_aih),null),
	coalesce(max(nr_sequencia),null)
into STRICT	nr_aih_antiga_w,
	nr_seq_aih_antiga_w
from 	sus_aih_unif
where 	nr_interno_conta	= nr_interno_conta_p;
if (coalesce(nr_aih_antiga_w::text, '') = '') then	
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263567); --Nao existe uma AIH nesta conta para ser substituida
end if;

/* Verificar se nova AIH ja existe, senao criar a mesma */

select	coalesce(max(nr_sequencia),null),
	coalesce(max(nr_interno_conta),null)
into STRICT	nr_seq_aih_nova_w,
	nr_interno_conta_w
from	sus_aih_unif
where	nr_aih	= nr_aih_nova_p;

if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') and (nr_interno_conta_w <> nr_interno_conta_p) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263568); --Nova AIH esta vinculada a outra conta
end if;

/* Criar nova aih */
	
if (coalesce(nr_seq_aih_nova_w::text, '') = '') then
	begin
	
	select 	nr_sequencia
	into STRICT	nr_seq_aih_nova_w
	from	sus_aih_unif	b
	where	b.nr_aih	= nr_aih_antiga_w
	and	b.nr_sequencia 	= nr_seq_aih_antiga_w;
	
	begin
	update	sus_aih_unif
	set	nr_aih		= nr_aih_nova_w,
		nr_anterior_aih	= CASE WHEN nr_anterior_aih='' THEN ''  ELSE nr_aih_nova_w END ,
		dt_atualizacao 	= clock_timestamp(),
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao_nrec = clock_timestamp(),
		nm_usuario_nrec = nm_usuario_p
	where	nr_aih	= nr_aih_antiga_w
	and	nr_sequencia 	= nr_seq_aih_antiga_w;
	exception
		when others then
			ds_erro_w := sqlerrm(SQLSTATE);
			CALL wheb_mensagem_pck.exibir_mensagem_abort(263569,'ds_erro_w='||ds_erro_w); --Ocorreu um erro ao criar a nova AIH!
	end;
	
	update	sus_laudo_paciente
	set	nr_aih	= nr_aih_nova_w
	where	nr_aih	= nr_aih_antiga_w;
	
	end;
end if;

begin
update	sus_registro_civil
set	nr_aih		= nr_aih_nova_w,
	nr_seq_aih	= nr_seq_aih_nova_w
where	nr_aih		= nr_aih_antiga_w;
exception
	when no_data_found then
		nr_aih_antiga_w	:= nr_aih_antiga_w;
	when others then		
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263570); --Ocorreu um erro ao atualizar os reg civil  desta AIH
end;	

begin
update	sus_laqueadura_vasectomia
set	nr_aih		= nr_aih_nova_w,
	nr_seq_aih	= nr_seq_aih_nova_w
where	nr_aih		= nr_aih_antiga_w;
exception
	when no_data_found then
		nr_aih_antiga_w	:= nr_aih_antiga_w;
	when others then		
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263571); --Ocorreu um erro ao atualizar a Laqueadura e vasectomia  desta AIH
end;	

begin
update	procedimento_paciente
set	nr_aih		= nr_aih_nova_w,
	nr_seq_aih	= nr_seq_aih_nova_w
where	nr_aih		= nr_aih_antiga_w;
exception
	when no_data_found then
		nr_aih_antiga_w	:= nr_aih_antiga_w;
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263572); --Ocorreu um erro ao atualizar os procedimentos desta AIH
end;	

begin
update	material_atend_paciente
set	nr_aih		= nr_aih_nova_w,
	nr_seq_aih	= nr_seq_aih_nova_w
where	nr_aih		= nr_aih_antiga_w;
exception
	when no_data_found then
		nr_aih_antiga_w	:= nr_aih_antiga_w;
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263573); --Ocorreu um erro ao atualizar os materiais desta AIH
end;	

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_substituir_aih_unif ( nr_interno_conta_p bigint, nr_aih_nova_p bigint, nm_usuario_p text, ie_consiste_aih_p text) FROM PUBLIC;


-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_convenio_autor_agenda (cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_agenda_p bigint, cd_convenio_new_p bigint, cd_convenio_old_p bigint, ie_autorizacao_p INOUT text) AS $body$
DECLARE


count_w			bigint;
nr_seq_estagio_w	bigint;
nr_seq_autorizacao_w	bigint;

c01 CURSOR FOR
SELECT	nr_sequencia
from	autorizacao_convenio
where	nr_seq_agenda	= nr_seq_agenda_p
and	cd_convenio	= cd_convenio_old_p;


BEGIN

select	count(*)
into STRICT	count_w
from	regra_gerar_autorizacao
where	cd_convenio		= cd_convenio_new_p
and	cd_estabelecimento	= cd_estabelecimento_p
and	ie_evento		= 'AP';

begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_estagio_w
	from	estagio_autorizacao
	where	ie_situacao = 'A'
	and	ie_interno  = 70
	and	OBTER_EMPRESA_ESTAB(wheb_usuario_pck.get_cd_estabelecimento) = cd_empresa;
exception
when no_data_found then
	/*r.aise_application_error(-20011, 'Não existe um estágio de cancelamento de autorização cadastrado!' ||
					 chr(13) || 'Verfique o cadastro de estãgio da autorização do convênio.');*/
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263280);
end;

ie_autorizacao_p	:= 'PA';

if (count_w = 0) then --Se não existe regra para este convênio, Cancela a Autorização e atualiza o agendamento.
	open C01;
	loop
	fetch C01 into
		nr_seq_autorizacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

		update	autorizacao_convenio
		set 	nr_seq_estagio	= nr_seq_estagio_w,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_autorizacao_w;

		insert into autorizacao_convenio_hist(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			ds_historico,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_sequencia_autor)
		values (nextval('autorizacao_convenio_hist_seq'),
			clock_timestamp(),
			nm_usuario_p,
			Wheb_mensagem_pck.get_texto(307843)/*'Convênio alterado no agendamento'*/
,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_autorizacao_w);
	end loop;
	close C01;

	ie_autorizacao_p := 'NN';

else --Se existe regra, apenas cancela a autorização
	open C01;
	loop
	fetch C01 into
		nr_seq_autorizacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

		update	autorizacao_convenio
		set 	nr_seq_estagio	= nr_seq_estagio_w,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_autorizacao_w;

		insert into autorizacao_convenio_hist(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			ds_historico,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_sequencia_autor)
		values (nextval('autorizacao_convenio_hist_seq'),
			clock_timestamp(),
			nm_usuario_p,
			Wheb_mensagem_pck.get_texto(307843) /*'Convenio alterado no agendamento'*/
,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_autorizacao_w);
	end loop;
	close C01;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_convenio_autor_agenda (cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_agenda_p bigint, cd_convenio_new_p bigint, cd_convenio_old_p bigint, ie_autorizacao_p INOUT text) FROM PUBLIC;

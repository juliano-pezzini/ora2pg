-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE com_encerrar_canal_antigo ( qt_dia_p bigint, cd_empresa_p bigint) AS $body$
DECLARE



nr_sequencia_w		bigint;
nr_seq_hist_w		bigint;
dt_historico_w		timestamp;
nr_seq_tipo_historico_w	bigint;
qt_dif_datas_w		bigint;
ds_email_w		varchar(2000);
ds_assunto_w		varchar(100);
ds_mensagem_w		varchar(2000);
ds_cliente_w		varchar(254);
ds_canal_w		varchar(254);
dt_fim_atuacao_w		timestamp;
ds_email_gestor_w		varchar(2000);
nm_fantasia_w		varchar(255);

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		substr(Obter_Desc_Cliente(a.nr_sequencia,'F'),1,255) nm_fantasia
	from	com_cliente a
	where	a.cd_empresa	= cd_empresa_p
	and	a.ie_classificacao 	in ('L','P')
	and	exists (	SELECT	1
			from	com_canal_cliente b
			where	a.nr_sequencia = b.nr_seq_cliente
			and	coalesce(b.dt_fim_atuacao::text, '') = ''
			and	b.ie_tipo_atuacao = 'V')
	and	((
		(select	obter_dias_entre_datas(coalesce(max(c.dt_historico),clock_timestamp()), clock_timestamp())
		from	com_cliente_hist c
		where	c.nr_seq_cliente  = a.nr_sequencia) <= qt_dia_p) OR
			not exists (select 1
			from	com_cliente_hist d
			where	d.nr_seq_cliente = a.nr_sequencia));

c02 CURSOR FOR
	SELECT	substr(obter_desc_cliente(a.nr_seq_cliente,'F'),1,254),
		substr(obter_dados_pf_pj(null,b.cd_cnpj,'N'),1,254)
	from	com_canal b,
		com_cliente c,
		com_canal_cliente a
	where	a.nr_seq_canal 	= b.nr_sequencia
	and	a.nr_seq_cliente	= c.nr_sequencia
	and	a.nr_seq_cliente 	= nr_sequencia_w
	and	c.ie_classificacao	in ('L','P')
	and	a.ie_tipo_atuacao	= 'V'
	and	((a.dt_fim_atuacao	= trunc(dt_fim_atuacao_w,'dd')) or (coalesce(a.dt_fim_atuacao::text, '') = ''));

c03 CURSOR FOR
	SELECT	coalesce(substr(obter_compl_pf(cd_pessoa_fisica,2,'M'),1,255),substr(obter_compl_pf(cd_pessoa_fisica,1,'M'),1,255))
	from	com_cliente_gestor
	where	nr_seq_cliente = nr_sequencia_w
	and	coalesce(dt_final::text, '') = '';


BEGIN

select	min(nr_sequencia)
into STRICT	nr_seq_tipo_historico_w
from	com_tipo_historico;

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	nm_fantasia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	dt_fim_atuacao_w := clock_timestamp();

	select	obter_dias_entre_datas(coalesce(max(c.dt_historico),clock_timestamp()), clock_timestamp())
	into STRICT	qt_dif_datas_w
	from	com_cliente_hist c
	where	c.nr_seq_cliente  = nr_sequencia_w;

	begin
	select	substr(obter_dados_pf_pj_estab(cd_empresa_p,null,cd_cgc,'M'),1,255) || ',' || 'lais@wheb.com.br' ||','|| 'comercial@wheb.com.br'
	into STRICT	ds_email_w
	from	pessoa_juridica
	where	cd_cgc = (	SELECT	max(c.cd_cnpj)
				from	com_canal c,
					com_canal_cliente b,
					com_cliente a
				where	a.nr_sequencia	= nr_sequencia_w
				and	a.nr_sequencia	= b.nr_seq_cliente
				and	b.nr_seq_canal	= c.nr_sequencia
				and	coalesce(b.dt_fim_atuacao::text, '') = '');
	exception
		when no_data_found then
		ds_email_w	:= 'lais@wheb.com.br' ||','|| 'comercial@wheb.com.br';
	end;

	if (qt_dif_datas_w >= qt_dia_p) or (qt_dif_datas_w = 0) then
		begin
		update	com_canal_cliente
		set	dt_fim_atuacao	= trunc(dt_fim_atuacao_w,'dd'),
			dt_atualizacao	= dt_fim_atuacao_w,
			nm_usuario	= 'Tasy'
		where	nr_seq_cliente	= nr_sequencia_w
		and	ie_tipo_atuacao	= 'V'
		and	coalesce(dt_fim_atuacao::text, '') = '';

		select	nextval('com_cliente_hist_seq')
		into STRICT	nr_seq_hist_w
		;

		insert into com_cliente_hist(
				nr_sequencia,
				nr_seq_cliente,
				dt_atualizacao,
				nm_usuario,
				nr_seq_canal,
				nr_seq_tipo,
				ds_historico,
				dt_historico,
				ds_titulo,
				dt_liberacao)
		values (	nr_seq_hist_w,
				nr_sequencia_w,
				clock_timestamp(),
				'Tasy',
				null,
				nr_seq_tipo_historico_w,
				'Canal encerrado de forma automatica pelo Tasy pois n?o tinha historico a ' ||
				qt_dia_p || ' dias.' || chr(13) ||
				'Ressaltamos que a partir de agora esta conta fica liberada para qualquer outro distribuidor atuar.',
				clock_timestamp(),
				'Encerramento automatico',
				clock_timestamp());
		end;
	end if;

	open c02;
	loop
	fetch c02 into
		ds_cliente_w,
		ds_canal_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		if (substr(ds_email_w,1,1) = ',') then
			ds_email_w := substr(ds_email_w,2,255);
		end if;

		open c03;
		loop
		fetch c03 into
			ds_email_gestor_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			ds_email_w	:= ds_email_w || ',' || ds_email_gestor_w;
			end;
		end loop;
		close c03;
		end;

		if (qt_dif_datas_w >= qt_dia_p) or (qt_dif_datas_w  = qt_dia_p - 3) or		/*Enviar alerta 3 dias antes do encerramento*/
			(qt_dif_datas_w  = 0) then
			begin
			ds_assunto_w		:= substr('Alerta de encerramento automatico da atuac?o: ' || nm_fantasia_w,1,60);
			if (qt_dif_datas_w > qt_dia_p) or (qt_dif_datas_w = 0) then
				ds_mensagem_w		:= 'A atuac?o do canal ' || ds_canal_w || ' no prospect ' || ds_cliente_w || ' foi encerrada automaticamente pelo Tasy pois n?o tinha historico a ' ||
							to_char(qt_dia_p) || ' dias.' || chr(13) || 'Ressaltamos que a partir de agora esta conta fica liberada para qualquer outro distribuidor atual.';
			elsif (qt_dif_datas_w = qt_dia_p - 3) then
				ds_mensagem_w		:= 'A atuac?o do canal ' || ds_canal_w || ' no prospect ' || ds_cliente_w || ' sera encerrada automaticamente pelo Tasy em 3 dias por falta de historico.';
			end if;

			CALL enviar_email(ds_assunto_w, ds_mensagem_w, 'comercial@wheb.com.br', ds_email_w,'Tasy','M');

			insert into com_cliente_envio(	nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_cliente,
							dt_envio,
							ie_tipo_envio,
							ds_destino,
							ds_observacao)
						values (	nextval('com_cliente_envio_seq'),
							clock_timestamp(),
							'Tasy',
							clock_timestamp(),
							'Tasy',
							nr_sequencia_w,
							clock_timestamp(),
							'J',
							substr(ds_email_w,1,255),
							'Job de encerramento de canal');
			end;
		end if;
	end loop;
	close c02;
	commit;
end loop;
close c01;

commit;

end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE com_encerrar_canal_antigo ( qt_dia_p bigint, cd_empresa_p bigint) FROM PUBLIC;


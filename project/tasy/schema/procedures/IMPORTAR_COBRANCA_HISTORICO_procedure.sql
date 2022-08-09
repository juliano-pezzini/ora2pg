-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_cobranca_historico ( ds_conteudo_p text, nm_usuario_p text, ie_commit_p text default 'N', ds_retorno_p INOUT text DEFAULT NULL, nr_seq_historico_p INOUT bigint DEFAULT NULL) AS $body$
DECLARE


/* Não dar commit nesta procedure. O commit vai ocorrer na Aplicação.*/

dt_historico_w		cobranca_historico.dt_historico%type;
nr_seq_cobranca_w	cobranca_historico.nr_seq_cobranca%type;
nr_seq_historico_w	cobranca_historico.nr_seq_historico%type;
vl_historico_w		cobranca_historico.vl_historico%type;
ds_historico_w		cobranca_historico.ds_historico%type;
qt_cobr_w			bigint;
ie_status_w			cobranca.ie_status%type;
qt_seq_hist_w		bigint;
qt_hist_importados_w	bigint;
ds_retorno_w		varchar(255) := '';
id_importacao_w		cobranca_historico.id_importacao%type;


BEGIN

if (ds_conteudo_p IS NOT NULL AND ds_conteudo_p::text <> '') then

	ds_retorno_p := 'N';

	/*Se tiver letras nas posicoes 1 a 60, ignorar. Aqui somente deve ter numeros.*/

	if (somente_letra(substr(ds_conteudo_p,1,60)) is null) then

		nr_seq_cobranca_w 	:= substr(ds_conteudo_p,2,10);
		dt_historico_w	 	:= to_date(substr(ds_conteudo_p,12,14),'dd/mm/yyyy hh24:mi:ss');
		nr_seq_historico_w  := substr(ds_conteudo_p,26,10);
		vl_historico_w		:= substr(ds_conteudo_p,36,15)/100;
		id_importacao_w		:= substr(ds_conteudo_p,51,10);
		ds_historico_w		:= substr(ds_conteudo_p,61,964);

	end if;

	if (nr_seq_cobranca_w IS NOT NULL AND nr_seq_cobranca_w::text <> '') then

		/*Verificar se a cobranca enviada no arquivo existe no Tasy.*/

		select	count(*)
		into STRICT	qt_cobr_w
		from	cobranca
		where	nr_sequencia = nr_seq_cobranca_w;

		if (qt_cobr_w = 0) then
				ds_retorno_w := substr(wheb_mensagem_pck.get_texto(795079) || '. ',1,255);
		end if;

		select	count(*)
		into STRICT	qt_seq_hist_w
		from	tipo_hist_cob
		where	nr_sequencia = nr_seq_historico_w;

		if (qt_seq_hist_w = 0) then
				ds_retorno_w := substr(ds_retorno_w || wheb_mensagem_pck.get_texto(795080) || '. ',1,255);
		end if;

		/*Se achar a cobrança e tiver o tipo de historico cadastrado no Tasy,*/

		if (qt_cobr_w > 0) and (qt_seq_hist_w > 0) then

			select 	max(ie_status)
			into STRICT	ie_status_w
			from	cobranca
			where	nr_sequencia = nr_seq_cobranca_w;

			select	count(*)
			into STRICT	qt_hist_importados_w
			from	cobranca_historico
			where	nr_seq_cobranca = nr_seq_cobranca_w
			and		id_importacao   = id_importacao_w;

			/*Se for diferente de Encerrada e Cancelada, inserir ao historico*/

			if (ie_status_w not in ('C','E')) then

				if (qt_hist_importados_w = 0) then



					insert into cobranca_historico( nr_sequencia,
													 nr_seq_cobranca,
													 dt_atualizacao,
													 nm_usuario,
													 nr_seq_historico,
													 vl_historico,
													 ds_historico,
													 dt_historico,
													 dt_atualizacao_nrec,
													 nm_usuario_nrec,
													 nr_seq_retorno,
													 id_importacao	)
										   values ( nextval('cobranca_historico_seq'),
													 nr_seq_cobranca_w,
													 clock_timestamp(),
													 nm_usuario_p,
													 nr_seq_historico_w,
													 vl_historico_w,
													 ds_historico_w,
													 dt_historico_w,
													 clock_timestamp(),
													 nm_usuario_p,
													 null,
													 id_importacao_w );

				end if;

			else
				ds_retorno_w := substr(ds_retorno_w || wheb_mensagem_pck.get_texto(795081) || '.',1,255);
			end if;

		end if;

		if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then

			ds_retorno_p := 'S';
			ds_retorno_w := substr(nr_seq_cobranca_w ||' - '|| ds_retorno_w,1,255);
			CALL fin_gerar_log_controle_banco( 99,
										  ds_retorno_w,
										  nm_usuario_p,
										  'N',
										  nr_seq_historico_w); --Não pode ter commit aqui.
			nr_seq_historico_p := nr_seq_historico_w;

		end if;
		/*No java precisa comitar aqui*/

		if (coalesce(ie_commit_p,'N') = 'S')	 then
			commit;
		end if;

	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_cobranca_historico ( ds_conteudo_p text, nm_usuario_p text, ie_commit_p text default 'N', ds_retorno_p INOUT text DEFAULT NULL, nr_seq_historico_p INOUT bigint DEFAULT NULL) FROM PUBLIC;

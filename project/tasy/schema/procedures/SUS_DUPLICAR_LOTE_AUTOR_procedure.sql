-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_duplicar_lote_autor ( nr_ser_lote_p bigint, ds_seq_laudo_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
nr_sequencia_w			bigint;
nr_seq_interno_w			bigint;
nr_seq_novo_w			bigint;
cd_estabelecimento_w		smallint;
ds_lote_w			varchar(60);
ie_tipo_lote_w			smallint;
ie_tipo_lote_apac_w		smallint;
nr_inicial_ordenacao_w		integer;
nr_atendimento_orig_w		bigint;
nr_atendimento_novo_w		bigint;
ie_dupl_atend_alta_w		varchar(5) := 'N';
ie_fechar_atend_alta_w		varchar(5) := 'N';
ds_erro_retorno_w			varchar(255) := '';
ds_erro_sql_w			varchar(2000) := '';
ds_erro_w			varchar(255) := '';
dt_obito_w			declaracao_obito.dt_obito%type;

c01 CURSOR FOR 
	SELECT	nr_seq_interno, 
		nr_atendimento 
	from	sus_laudo_paciente 
	where	nr_seq_lote = nr_ser_lote_p 
	and	((coalesce(ds_seq_laudo_p,'X') = 'X') or (obter_se_contido(nr_seq_interno,ds_seq_laudo_p) = 'S'));


BEGIN 
ie_dupl_atend_alta_w 	:= obter_valor_param_usuario(1006, 22, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);
ie_fechar_atend_alta_w	:= obter_valor_param_usuario(1006, 25, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);
 
select	cd_estabelecimento, 
	ds_lote, 
	ie_tipo_lote, 
	ie_tipo_lote_apac, 
	nr_inicial_ordenacao 
into STRICT	cd_estabelecimento_w, 
	ds_lote_w, 
	ie_tipo_lote_w, 
	ie_tipo_lote_apac_w, 
	nr_inicial_ordenacao_w 
from	sus_lote_autor 
where	nr_sequencia = nr_ser_lote_p;
 
select	nextval('sus_lote_autor_seq') 
into STRICT	nr_sequencia_w
;
 
insert into sus_lote_autor( 
		nr_sequencia, 
		cd_estabelecimento, 
		ds_lote, 
		ie_tipo_lote, 
		ie_tipo_lote_apac, 
		nr_inicial_ordenacao, 
		dt_atualizacao, 
		dt_atualizacao_nrec, 
		nm_usuario, 
		nm_usuario_nrec, 
		nr_seq_lote_origem) 
	values (	nr_sequencia_w, 
		cd_estabelecimento_w, 
		ds_lote_w||WHEB_MENSAGEM_PCK.get_texto(279719), 
		ie_tipo_lote_w, 
		ie_tipo_lote_apac_w, 
		nr_inicial_ordenacao_w, 
		clock_timestamp(), 
		clock_timestamp(), 
		nm_usuario_p, 
		nm_usuario_p, 
		nr_ser_lote_p);
 
open c01;
loop 
fetch c01 into 
	nr_seq_interno_w, 
	nr_atendimento_orig_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	ds_erro_sql_w := '';
	delete from sus_laudo_paciente_hist 
	where	nr_seq_laudo = nr_seq_interno_w;	
	 
	if	((coalesce(ie_dupl_atend_alta_w,'N') = 'N') or 
		((coalesce(ie_dupl_atend_alta_w,'N') = 'S') and (obter_se_atendimento_alta(nr_atendimento_orig_w) = 'S'))) then 
		begin	 
		 
		begin 
			 
			begin 
			 
				select	b.dt_obito 
				into STRICT	dt_obito_w	 
				from	atendimento_paciente a, 
					pessoa_fisica b 
				where	a.cd_pessoa_fisica = b.cd_pessoa_fisica 
				and	a.nr_atendimento = nr_atendimento_orig_w;
			 
			exception 
			when others then 
				dt_obito_w := null;
			end;
			 
			if (coalesce(dt_obito_w::text, '') = '') then 
		 
				nr_atendimento_novo_w := sus_duplicar_atendimento_laudo(nr_atendimento_orig_w, nr_seq_interno_w, nm_usuario_p, nr_atendimento_novo_w, ie_tipo_lote_w);
				 
			end if;
		exception 
		when others then 
			ds_erro_sql_w := substr(sqlerrm,1,2000);
		end;		
		 
		if (coalesce(ie_fechar_atend_alta_w,'N') = 'S') then 
			begin 
			ds_erro_w := finalizar_atendimento(nr_atendimento_orig_w, 'S', nm_usuario_p, ds_erro_w);
			if (coalesce(ds_erro_w,'X') <> 'X') then 
				ds_erro_retorno_w := substr(ds_erro_retorno_w|| nr_atendimento_orig_w ||', ',1,255);
			end if;
			end;
		end if;
		 
		if (coalesce(nr_atendimento_novo_w,0) <> 0) then 
			begin 
			ds_erro_sql_w := '';
			begin 
			nr_seq_novo_w := duplicar_sus_laudo_paciente(	nr_seq_interno_w, nr_atendimento_novo_w, nm_usuario_p, nr_seq_novo_w);
			exception 
			when others then 
				ds_erro_sql_w := substr(sqlerrm,1,2000);
			end;
			 
		 
			if (coalesce(nr_seq_novo_w,0) <> 0) then 
					begin 
				update	sus_laudo_paciente 
				set	nr_seq_lote = nr_sequencia_w 
				where	nr_seq_interno = nr_seq_novo_w;
				end;
			else 
				begin 
				insert into sus_laudo_paciente_hist( 
					nr_sequencia, 
					dt_atualizacao, 
					nm_usuario, 
					nr_seq_laudo, 
					dt_historico, 
					ds_historico, 
					cd_pessoa_fisica, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec) 
				values ( nextval('sus_laudo_paciente_hist_seq'), 
					clock_timestamp(), 
					nm_usuario_p, 
					nr_seq_interno_w, 
					clock_timestamp(), 
					substr(WHEB_MENSAGEM_PCK.get_texto(279720)|| ds_erro_sql_w,1,2000), 
					obter_pessoa_atendimento(nr_atendimento_orig_w,'C'), 
					clock_timestamp(), 
					nm_usuario_p);			
				end;
			end if;
		 
			end;
		else 
			begin 
			insert into sus_laudo_paciente_hist( 
					nr_sequencia, 
					dt_atualizacao, 
					nm_usuario, 
					nr_seq_laudo, 
					dt_historico, 
					ds_historico, 
					cd_pessoa_fisica, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec) 
				values ( nextval('sus_laudo_paciente_hist_seq'), 
					clock_timestamp(), 
					nm_usuario_p, 
					nr_seq_interno_w, 
					clock_timestamp(), 
					substr(WHEB_MENSAGEM_PCK.get_texto(279721)|| nr_atendimento_orig_w ||WHEB_MENSAGEM_PCK.get_texto(279722)|| ds_erro_sql_w,1,2000), 
					obter_pessoa_atendimento(nr_atendimento_orig_w,'C'), 
					clock_timestamp(), 
					nm_usuario_p);
			end;
		end if;	
	 
		 
		 
		end;
	else 
		begin 
		insert into sus_laudo_paciente_hist( 
			nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_laudo, 
			dt_historico, 
			ds_historico, 
			cd_pessoa_fisica, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec) 
		values (	nextval('sus_laudo_paciente_hist_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_interno_w, 
			clock_timestamp(), 
			substr(WHEB_MENSAGEM_PCK.get_texto(279725)||nr_atendimento_orig_w||WHEB_MENSAGEM_PCK.get_texto(279727),1,2000), 
			obter_pessoa_atendimento(nr_atendimento_orig_w,'C'), 
			clock_timestamp(), 
			nm_usuario_p);	
		end;
	end if;
	end;
end loop;
close c01;
 
ds_erro_p 		:= substr(ds_erro_retorno_w,1,255);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_duplicar_lote_autor ( nr_ser_lote_p bigint, ds_seq_laudo_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;


-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_gerar_aprov_revisao ( nr_seq_revisao_p bigint, cd_pessoa_aprov_p text, dt_aprovacao_p timestamp, nm_usuario_p text, ie_ult_aprovador_p INOUT text) AS $body$
DECLARE

				
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Aprovar a revisão de um documento quando houverem múltiplos aprovadores
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------

Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_existe_w			integer;
nr_seq_revisao_w		bigint;
cd_pessoa_atual_w		varchar(10);
cd_estabelecimento_w		smallint := wheb_usuario_pck.get_cd_estabelecimento;
cd_cargo_w			bigint;
nr_seq_doc_w			bigint;
nr_seq_tipo_w			bigint;
nr_seq_classif_w		bigint;
dt_aprov_doc_w			timestamp;
dt_valid_doc_w			timestamp;
dt_elab_doc_w			timestamp;
ie_status_w			varchar(01);


BEGIN
select	count(1)
into STRICT	qt_existe_w
from	qua_doc_revisao_aprovacao
where	nr_seq_revisao	= nr_seq_revisao_p
and	coalesce(dt_aprovacao::text, '') = ''  LIMIT 1;

select	a.cd_cargo,
	coalesce(cd_pessoa_aprov_p, a.cd_pessoa_fisica)
into STRICT	cd_cargo_w,
	cd_pessoa_atual_w
from	pessoa_fisica	a,
	usuario		b
where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica
and	b.nm_usuario 		= nm_usuario_p;

ie_ult_aprovador_p	:= 'N';

/*Se não existir mais de um aprovador faz o processo normal*/

if (qt_existe_w = 0) then
	begin
	update 	qua_doc_revisao
	set 	dt_atualizacao 		= clock_timestamp(),
		nm_usuario 		= nm_usuario_p,
		dt_aprovacao 		= dt_aprovacao_p,
		nm_usuario_aprovacao 	= nm_usuario_p
	where 	nr_sequencia 		= nr_seq_revisao_p;
	
	ie_ult_aprovador_p	:= 'S';
	end;
else
	begin
	/*Se existir mais de um aprovador, busca a sequencia de aprovação da pessoa que está aprovando*/

	select	count(*),
		max(nr_sequencia)
	into STRICT	qt_existe_w,
		nr_seq_revisao_w
	from	qua_doc_revisao_aprovacao
	where	nr_seq_revisao	= nr_seq_revisao_p
	and	((cd_pessoa_aprov = cd_pessoa_atual_w) or (cd_cargo = cd_cargo_w))
	and	coalesce(dt_aprovacao::text, '') = '';

	if (qt_existe_w > 0) and (coalesce(nr_seq_revisao_w,0) > 0) then
		
		update	qua_doc_revisao_aprovacao
		set	dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p,
			dt_aprovacao	= dt_aprovacao_p
		where	nr_sequencia 	= nr_seq_revisao_w;

		/*Vê se existe alguma aprovação pendente ainda, senão, aprova a revisão*/

		select	count(1)
		into STRICT	qt_existe_w
		from	qua_doc_revisao_aprovacao
		where	nr_seq_revisao	= nr_seq_revisao_p
		and	coalesce(dt_aprovacao::text, '') = ''  LIMIT 1;

		if (qt_existe_w = 0) then
			begin
			update	qua_doc_revisao
			set 	dt_atualizacao 		= clock_timestamp(),
				nm_usuario 		= nm_usuario_p,
				dt_aprovacao 		= dt_aprovacao_p,
				nm_usuario_aprovacao 	= nm_usuario_p
			where 	nr_sequencia 		= nr_seq_revisao_p;

			CALL qua_gerar_envio_comunicacao(	nr_seq_revisao_p,
							'0',
							nm_usuario_p,
							'13',
							cd_estabelecimento_w,
							null,
							null,
							'N');
			
			select	a.nr_sequencia,
				a.dt_aprovacao,
				a.dt_validacao,
				a.dt_elaboracao,
				a.nr_seq_classif,
				a.nr_seq_tipo
			into STRICT	nr_seq_doc_w,
				dt_aprov_doc_w,
				dt_valid_doc_w,
				dt_elab_doc_w,
				nr_seq_classif_w,
				nr_seq_tipo_w
			from	qua_documento	a,
				qua_doc_revisao	b
			where	a.nr_sequencia	= b.nr_seq_doc
			and	b.nr_sequencia	= nr_seq_revisao_p;			

			CALL qua_gravar_doc_log_acesso(	nr_seq_doc_w,
							'C',
							nm_usuario_p);
			
			if (dt_aprov_doc_w IS NOT NULL AND dt_aprov_doc_w::text <> '') then
				if (	nr_seq_classif_w = 1
					and	nr_seq_tipo_w in (2, 3, 5, 15)
					and (	obter_se_base_corp = 'S'
						or	obter_se_base_wheb = 'S')) then
					ie_status_w	:= 'T';
				else
					ie_status_w	:= 'D';
				end if;
			else
				begin
				if (dt_valid_doc_w IS NOT NULL AND dt_valid_doc_w::text <> '') then
					ie_status_w	:= 'V';
				elsif (dt_elab_doc_w IS NOT NULL AND dt_elab_doc_w::text <> '') then
					ie_status_w	:= 'E';
				else	
					ie_status_w	:= 'P';
				end if;
				end;
			end if;

			if (coalesce(ie_status_w,'0') <> '0') then
				CALL qua_atualizar_status_doc(	nr_seq_doc_w,
								ie_status_w,
								nm_usuario_p);
			end if;

			CALL aprov_rev_idiomas_doc(nr_seq_doc_w, dt_aprovacao_p, nm_usuario_p, ie_status_w);
			
			ie_ult_aprovador_p	:= 'S';
			end;
		end if;
	end if;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_gerar_aprov_revisao ( nr_seq_revisao_p bigint, cd_pessoa_aprov_p text, dt_aprovacao_p timestamp, nm_usuario_p text, ie_ult_aprovador_p INOUT text) FROM PUBLIC;

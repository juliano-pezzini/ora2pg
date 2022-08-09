-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE apap_modifica_registros ( nr_seq_valor_p bigint, ie_opcao_p text) AS $body$
DECLARE


nm_usuario_w			usuario.nm_usuario%type	:=	wheb_usuario_pck.get_nm_usuario;
nr_seq_origem_w			w_apap_pac_registro.nr_sequencia%type;
nm_tabela_w				w_apap_pac_informacao.nm_tabela%type;
dt_registro_w			w_apap_pac_registro.dt_registro%type;
nr_seq_apap_grupo_w		w_apap_pac_informacao.nr_seq_apap_grupo%type;
ie_status_houdini_w     w_apap_pac_registro.IE_STATUS_HOUDINI%type;
nr_seq_mod_apap_w		w_apap_pac.nr_sequencia%type;

BEGIN
/*
ie_opcao_p
ID 	- Editar Coluna da Secao - Inativar o liberado e duplicar sem liberacao
IC 	- Limpar Celula - Inativar/Excluir o campo liberado e duplicar sem liberacao, porem sem duplicar o campo
I	  - Exclur coluna da secao - Inativar o registro todo. Seria o excluir a coluna
ER  - OBs: ao sair do apap - Excluir todos os registros pendentes do usuario
*/
select	max(a.nr_seq_origem),
		max(b.nm_tabela),
		max(a.dt_registro),
		max(b.nr_seq_apap_grupo),
        max(a.IE_STATUS_HOUDINI),
		max(c.nr_seq_mod_apap)
into STRICT	nr_seq_origem_w,
		nm_tabela_w,
		dt_registro_w,
		nr_seq_apap_grupo_w,
        ie_status_houdini_w,
		nr_seq_mod_apap_w
from	w_apap_pac_registro a,
		w_apap_pac_informacao b,
		w_apap_pac_grupo c
where	a.nr_seq_apap_inf	= b.nr_sequencia
and		b.nr_seq_apap_grupo = c.nr_sequencia
and		a.nr_sequencia 		= nr_seq_valor_p;

if (ie_status_houdini_w <> 'L' AND (nr_seq_origem_w IS NOT NULL AND nr_seq_origem_w::text <> '') and (nm_tabela_w IS NOT NULL AND nm_tabela_w::text <> '')) then
	if (ie_opcao_p in ('ID','I','IC')) then
		CALL inativar_informacao(nm_tabela_w,'nr_sequencia',nr_seq_origem_w,null,nm_usuario_w);
		if (ie_opcao_p in ('ID','IC')) then
			insert	into	w_apap_pac_registro(	nr_sequencia,
													dt_atualizacao,
													nm_usuario,
													dt_atualizacao_nrec,
													nm_usuario_nrec,
													nr_seq_origem,
													dt_registro,
													vl_resultado,
													ds_resultado,
													nr_seq_apap_inf,
													dt_medicao,
													dt_resultado,
													dt_inicio,
													dt_fim,
													vl_pas,
													vl_pam,
													vl_pad,
													vl_papd,
													vl_paps,
													vl_papm,
													ds_profissional,
													ie_alerta,
													ie_situacao)
													SELECT	nextval('w_apap_pac_registro_seq'),
															clock_timestamp(),
															nm_usuario_w,
															clock_timestamp(),
															nm_usuario_w,
															null,
															dt_registro,
															vl_resultado,
															ds_resultado,
															nr_seq_apap_inf,
															dt_medicao,
															dt_resultado,
															dt_inicio,
															dt_fim,
															vl_pas,
															vl_pam,
															vl_pad,
															vl_papd,
															vl_paps,
															vl_papm,
															ds_profissional,
															ie_alerta,
															'A'
													from	w_apap_pac_registro
													where	nr_seq_origem = nr_seq_origem_w
													and		((ie_opcao_p = 'ID') or (ie_opcao_p = 'IC' AND nr_sequencia <> nr_seq_valor_p));

			delete	
			from	w_apap_pac_registro
			where	nr_seq_origem 	= nr_seq_origem_w
			and		((ie_opcao_p 	= 'ID') or (ie_opcao_p = 'IC' AND nr_sequencia <> nr_seq_valor_p));
		end if;	
	end if;
elsif (ie_opcao_p in ('I','IC')) then --quando nao houve ainda a liberacao
	if (ie_opcao_p = 'IC') then 	--limpar celula
		delete	
		from	w_apap_pac_registro
		where	nr_sequencia 	= nr_seq_valor_p;
	else							--excluir valores da coluna do grupo
		delete	
		from	w_apap_pac_registro a
		where	exists (SELECT 	1
						from	w_apap_pac_informacao b
						where	b.nr_sequencia 		= a.nr_seq_apap_inf
						and		b.nr_seq_apap_grupo	= nr_seq_apap_grupo_w)
		and		a.dt_registro 	= dt_registro_w
		and (coalesce(a.nr_seq_origem::text, '') = '' OR IE_STATUS_HOUDINI = 'L')
		and		coalesce(a.ie_situacao,'A') = 'A';
	end if;	
elsif (ie_opcao_p = 'ER') then
	/*
	delete	
	from	w_apap_pac_registro
	where	nm_usuario 		= nm_usuario_w
	and   	nr_sequencia  	= nr_seq_valor_p
	and		(nr_seq_origem	is null OR IE_STATUS_HOUDINI = 'L');
	*/
	delete
	from	w_apap_pac_registro a
	where	exists (SELECT	1 
					from	w_apap_pac_informacao b,
							w_apap_pac_grupo c
					where	a.nr_seq_apap_inf 	= b.nr_sequencia
					and		b.nr_seq_apap_grupo	= c.nr_sequencia
					and		c.nr_seq_mod_apap	= nr_seq_mod_apap_w)
	and (coalesce(a.nr_seq_origem::text, '') = '' OR a.ie_status_houdini = 'L')
	and		coalesce(a.ie_situacao,'A') = 'A';
end if;

commit;
											
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE apap_modifica_registros ( nr_seq_valor_p bigint, ie_opcao_p text) FROM PUBLIC;

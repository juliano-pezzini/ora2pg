-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_hemocomponente_barras (nr_seq_producao_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_possui_sorologia_w 		varchar(1);
ie_possui_exame_pendente_w 	varchar(1);
nr_seq_doacao_w       		san_producao.nr_seq_doacao%type;


BEGIN
if (nr_seq_producao_p IS NOT NULL AND nr_seq_producao_p::text <> '') or (nr_seq_producao_p <> 0) then

	select max(nr_seq_doacao)
	into STRICT nr_seq_doacao_w
	from san_producao
	where nr_sequencia = nr_seq_producao_p;

	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT 	ie_possui_exame_pendente_w
	FROM	san_doacao
	WHERE 	nr_sequencia = nr_seq_doacao_w
	AND	NOT EXISTS ( 	SELECT 1	
				FROM	san_exame_lote a,
					san_exame_realizado b,
					san_exame c
				WHERE	a.nr_sequencia 	= b.nr_seq_exame_lote
				AND	c.nr_sequencia	= b.nr_seq_exame
				AND	a.nr_seq_doacao	= nr_seq_doacao_w
				AND 	((san_obter_se_exame_auxiliar(a.nr_sequencia,b.nr_seq_exame,1,'S') = 'S') 
					OR (san_obter_se_exame_auxiliar(a.nr_sequencia,b.nr_seq_exame,1,'O') = 'S')) 
				AND	coalesce(b.dt_liberacao::text, '') = '');
				
	if (ie_possui_exame_pendente_w <> 'S') then
		CALL wheb_mensagem_pck.Exibir_mensagem_abort(1107051);
	end if;

	select	CASE WHEN Count(*)=0 THEN 'S'  ELSE 'N' END
	into STRICT   	ie_possui_sorologia_w 
	from   	san_exame_lote a, 
		san_exame_realizado b, 
		san_exame c 
	where  a.nr_sequencia = b.nr_seq_exame_lote 
	and c.nr_sequencia = b.nr_seq_exame 
	and a.nr_seq_doacao = nr_seq_doacao_w
	and (San_obter_destino_exame(b.nr_seq_exame,3) = 'S' or San_obter_destino_exame(b.nr_seq_exame, 0) = 'S' ) 
	and (Upper(b.ds_resultado) IN ('POSITIVO', 'REAGENTE', 'INDETERMINADO') or san_se_bloqueia_exames_valores(nr_seq_doacao_w) = 'S') 
	and (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') 
	and coalesce(c.ie_fator_rh,'N') = 'N' 
	and coalesce(c.ie_consiste_result_pos,'S') = 'S' 
	and not exists (SELECT	1 
			from  	san_parametro p 
			where 	p.cd_estabelecimento = obter_estabelecimento_ativo
			and 	p.nr_seq_exame_rh = b.nr_seq_exame) 
	and not exists ( select 1 
			from   san_doacao d 
			where  d.nr_sequencia = a.nr_seq_doacao 
			and coalesce(ie_apto_amostra, 'N') = 'S') 
	and a.nr_sequencia = 	(select max(nr_sequencia) 
							from   san_exame_lote 
							where  nr_seq_doacao = a.nr_seq_doacao);
    
	if (ie_possui_sorologia_w <> 'S') then 
		--Nao e possivel liberar o hemocomponente pois ha exame com sorologia positiva.
		CALL wheb_mensagem_pck.Exibir_mensagem_abort(1091568);
	else
		update	san_producao
		set	dt_liberacao	= clock_timestamp(),
			nm_usuario_lib	= nm_usuario_p
		where	nr_sequencia	= nr_seq_producao_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_hemocomponente_barras (nr_seq_producao_p bigint, nm_usuario_p text) FROM PUBLIC;

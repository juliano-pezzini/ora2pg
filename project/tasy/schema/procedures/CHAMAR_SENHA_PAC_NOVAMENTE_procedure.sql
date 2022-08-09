-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE chamar_senha_pac_novamente ( nr_seq_senha_p bigint, nm_maquina_atual_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_excedeu_chamadas_p INOUT text) AS $body$
DECLARE

 
nr_sequencia_w			bigint;
qt_chamadas_atual_w		bigint;
qt_max_chamadas_w		bigint;
ie_utiliza_oracle_alert_w	varchar(2);
nm_usuario_chamada_w		varchar(20);
ie_consiste_usuario_w 		varchar(2);
dt_ultima_chamada_w		timestamp;
ie_rechamada_w			varchar(1);
dt_rechamada_w			timestamp;

BEGIN
 
ie_consiste_usuario_w := Obter_Param_Usuario(10021, 61, Obter_perfil_Ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_usuario_w);
 
select 	max(nm_usuario_chamada), 
	max(ie_rechamada), 
	max(dt_nova_chamada) 
into STRICT	nm_usuario_chamada_w, 
	ie_rechamada_w, 
	dt_rechamada_w 
from	paciente_senha_fila 
where	(dt_primeira_chamada IS NOT NULL AND dt_primeira_chamada::text <> '') 
and	nr_sequencia = nr_seq_senha_p;
 
select	max(dt_atualizacao_nrec) 
into STRICT	dt_ultima_chamada_w 
from	paciente_senha_fila_hist 
where	nr_seq_senha = nr_seq_senha_p;
 
if	((ie_consiste_usuario_w = 'S') or 
	((ie_consiste_usuario_w = 'M') and (obter_se_usuario_medico(nm_usuario_chamada_w) = 'S') and (obter_se_usuario_medico(nm_usuario_p) = 'S'))) and 
	((coalesce(dt_rechamada_w::text, '') = '') or (dt_ultima_chamada_w < dt_rechamada_w)) then 
	if (nm_usuario_chamada_w IS NOT NULL AND nm_usuario_chamada_w::text <> '') and (nm_usuario_chamada_w <> nm_usuario_p) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(227548, 'NM_USUARIO_CHAMADA= ' || nm_usuario_chamada_w);
	elsif (coalesce(nm_usuario_chamada_w::text, '') = '') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(227546, '');
	end if;
end if;
 
SELECT Obter_Valor_Param_Usuario(10021,24,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p), 
	coalesce(Obter_Valor_Param_Usuario(10021,56,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p),'N') 
INTO STRICT 	qt_max_chamadas_w, 
	ie_utiliza_oracle_alert_w
;
 
SELECT	max(a.nr_sequencia) 
INTO STRICT	nr_sequencia_w 
FROM	maquina_local_senha a, 
	computador b 
WHERE	a.nr_seq_computador	= b.nr_sequencia 
AND	b.cd_estabelecimento 	= cd_estabelecimento_p 
AND	nm_computador_pesquisa 	= padronizar_nome(UPPER(nm_maquina_atual_p)) 
and	coalesce(a.ie_situacao, 'A') = 'A';
 
CALL ATUALIZAR_SENHA_MONITOR(nr_seq_senha_p,'L');
 
UPDATE	paciente_senha_fila 
SET	dt_chamada		= clock_timestamp(), 
	ds_maquina_chamada	= nm_maquina_atual_p, 
	nr_seq_local_senha	= nr_sequencia_w, 
	qt_chamadas		= coalesce(qt_chamadas,0) + 1, 
	nm_usuario		= nm_usuario_p, 
	ie_forma_chamada    =    'N', 
	dt_primeira_chamada	= CASE WHEN dt_primeira_chamada = NULL THEN clock_timestamp()  ELSE dt_primeira_chamada END  
WHERE	nr_sequencia		= nr_seq_senha_p;
--AND	dt_vinculacao_senha IS NULL 
--AND	dt_utilizacao IS NULL; 
 
IF (ie_utiliza_oracle_alert_w = 'S') THEN 
	CALL verificar_senha_nova_signal(nm_usuario_p);
END IF;
 
SELECT 	coalesce(MAX(qt_chamadas),0) 
INTO STRICT	qt_chamadas_atual_w 
FROM 	paciente_senha_fila 
WHERE 	nr_sequencia = nr_seq_senha_p;
 
ie_excedeu_chamadas_p := 'N';
IF (qt_chamadas_atual_w > qt_max_chamadas_w) AND (qt_max_chamadas_w > 0)	THEN 
	ie_excedeu_chamadas_p := 'S';
	 
	UPDATE	paciente_senha_fila 
	SET	dt_inutilizacao 	= clock_timestamp(), 
		nm_usuario_inutilizacao = wheb_usuario_pck.get_nm_usuario, 
		ds_maquina_inutilizacao = wheb_usuario_pck.get_nm_maquina 
	WHERE	nr_sequencia = nr_seq_senha_p;
	 
	update	atendimento_paciente 
	set 	ie_chamado = 'X', 
		dt_atualizacao = clock_timestamp(), 
		nm_usuario = nm_usuario_p 
	where	nr_seq_pac_senha_fila = nr_seq_senha_p;
	 
END IF;
 
COMMIT;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE chamar_senha_pac_novamente ( nr_seq_senha_p bigint, nm_maquina_atual_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_excedeu_chamadas_p INOUT text) FROM PUBLIC;

-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW psa_tasy_parameter (login, alternative_login, replacement_login, login_attempts, expiration_time, allowed_simultaneous_sessions) AS SELECT
        ssu.login,
        ssu.alternative_login,
        ssu.replacement_login,
        ssu.login_attempts,
        ssu.expiration_time,
        ssu.allowed_simultaneous_sessions
    FROM (
            SELECT
                usuario.nm_usuario login,
                usuario.ds_login alternative_login,
                '' replacement_login,
                substr(obter_valor_param_usuario(0,84,0,nm_usuario,cd_estabelecimento),1,10) login_attempts,
                substr(obter_valor_param_usuario(0,91,0,nm_usuario,cd_estabelecimento),1,10) expiration_time,
                substr(obter_valor_param_usuario(0,199,0,nm_usuario,cd_estabelecimento),1,10) allowed_simultaneous_sessions
            FROM
                usuario
        ) ssu;
